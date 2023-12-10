import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:geek_chat/controller/chat_message_controller.dart';
import 'package:geek_chat/controller/chat_session_controller.dart';
import 'package:geek_chat/controller/question_input_controller.dart';
import 'package:geek_chat/controller/settings_server_controller.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/util/app_constants.dart';
import 'package:geek_chat/util/geeker_ai_utils.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class InputSubmitUtil {
  InputSubmitUtil._();

  static final InputSubmitUtil _instance = InputSubmitUtil._();
  static InputSubmitUtil get instance => _instance;

  final Logger logger = Get.find();

  Future<void> submitImageModel(
      ChatMessageController chatMessageController,
      ChatSessionController chatSessionController,
      QuestionInputController questionInputController,
      SettingsServerController settingsServerController) async {
    MessageModel userMessage = chatMessageController.createNewMessage(
        chatSessionController.currentSession.sid,
        'user',
        questionInputController.inputText,
        false);
    userMessage.model = chatSessionController.currentSession.model;
    userMessage.status = 1;

    /// request openai
    try {
      chatMessageController.addMessage(userMessage);
      chatMessageController.update();
      OpenAI openAI = GeekerAIUtils.instance
          .getOpenaiInstance(settingsServerController.defaultServer);
      OpenAIImageModel images = await openAI.image.create(
        model: chatSessionController.currentSession.model,
        prompt: questionInputController.inputText,
        n: int.parse(questionInputController.defaultImageN),
        size: AppConstants.getGeekerAIImageSize(
                questionInputController.questionInputModel.imageParameterSize!)
            .openAIImageSize,
        quality: AppConstants.getGeekerAIImageQuality(questionInputController
                .questionInputModel.imageParameterQuality!)
            .openAIImageQuality,
        style: AppConstants.getGeekerAIImageStyle(
                questionInputController.questionInputModel.imageParameterStyle!)
            .openAIImageStyle,
      );
      logger.d("image model: ${images.json.toString()}");
      OpenAIImageData image = images.data.first;
      logger.d("image url: ${image.url}");
      logger.d("image revise: ${image.revisedPrompt}");
      // logger.d("image json: ${image}");
      if (images.haveData) {
        MessageModel targetMessage = chatMessageController.createNewMessage(
            chatSessionController.currentSession.sid, 'assistant', '', false);
        targetMessage.responseJson = jsonEncode(images.json);
        targetMessage.status = 1;
        chatMessageController.addMessage(targetMessage);
        chatMessageController.update();
        chatMessageController.saveMessage(userMessage);
        chatMessageController.saveMessage(targetMessage);
        chatSessionController.saveSession(chatSessionController.currentSession);
        chatSessionController.update();
      }
    } on RequestFailedException catch (e) {
      logger.e("getOpenAIInstance error: ${e.message}");
      MessageModel targetMessage = chatMessageController.createNewMessage(
          chatSessionController.currentSession.sid, 'assistant', '', false);
      // targetMessage.responseJson = jsonEncode(images.json);
      targetMessage.content = e.message;
      targetMessage.status = 1;
      chatMessageController.addMessage(targetMessage);
      chatMessageController.update();
      chatMessageController.saveMessage(userMessage);
      chatMessageController.saveMessage(targetMessage);
      chatSessionController.saveSession(chatSessionController.currentSession);
      chatSessionController.update();
    } on Exception catch (e) {
      logger.e("getOpenAIInstance error: ${e}");
    }
  }
}

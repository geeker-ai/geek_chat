import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:geek_chat/controller/chat_message_controller.dart';
import 'package:geek_chat/controller/chat_session_controller.dart';
import 'package:geek_chat/controller/question_input_controller.dart';
import 'package:geek_chat/controller/settings_server_controller.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/session.dart';
import 'package:geek_chat/util/app_constants.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:geek_chat/util/geeker_ai_utils.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class InputSubmitUtil {
  InputSubmitUtil._();

  static final InputSubmitUtil _instance = InputSubmitUtil._();
  static InputSubmitUtil get instance => _instance;

  final Logger logger = Get.find();

  Future<void> submitChatModel(
    ChatMessageController chatMessageController,
    ChatSessionController chatSessionController,
    QuestionInputController questionInputController,
    SettingsServerController settingsServerController,
  ) async {
    /// 创建用户输入的Message
    MessageModel userMessage = MessageModel(
      msgId: const Uuid().v4(),
      role: MessageRole.user.name,
      content: questionInputController.inputText,
      sId: chatSessionController.currentSession.sid,
      model: chatSessionController.currentSession.model,
      msgType: 1,
      synced: false,
      generating: false,
      updated: getCurrentDateTime(),
    );

    ///  将 Message 放到列表里
    chatMessageController.addMessage(userMessage);
    chatMessageController.update();
    try {
      OpenAI openai = GeekerAIUtils.instance
          .getOpenaiInstance(settingsServerController.defaultServer);
      Stream<OpenAIStreamChatCompletionModel> chatCompletionStream =
          openai.chat.createStream(
        model: userMessage.model!,
        messages: getChatHistoryMessages(chatMessageController.messages,
            chatSessionController.currentSession, userMessage),
        // toolChoice: "auto",
        temperature: chatSessionController.currentSession.temperature,
        // responseFormat: {"type": "json_object"},
        // user:
        // seed: 6, //https://platform.openai.com/docs/api-reference/chat/create
      );

      /// create Assistant Message
      MessageModel targetMessage = MessageModel(
        msgId: const Uuid().v4(),
        role: MessageRole.assistant.name,
        content: "",
        sId: chatSessionController.currentSession.sid,
        model: chatSessionController.currentSession.model,
        msgType: 1,
        synced: false,
        updated: getCurrentDateTime(),
        generating: true,
      );
      chatMessageController.addMessage(targetMessage);
      chatMessageController.update();
      chatCompletionStream.listen((event) {
        logger.d("chat completion event: ${event.toString()} ");
        final List<OpenAIChatCompletionChoiceMessageContentItemModel>? content =
            event.choices.first.delta.content;
        // targetMessage.content = content;
        if (content != null) {
          for (OpenAIChatCompletionChoiceMessageContentItemModel item
              in content) {
            targetMessage.content =
                "${targetMessage.content}${item.text ?? ''}";
            logger.d("target message: ${targetMessage.content}");
            if (targetMessage.generating == true) {
              targetMessage.streamContent = targetMessage.content;
            }
          }
        }
      }, onDone: () {
        logger.d("stream message is done");
        targetMessage.generating = false;
        targetMessage.contentStream!.close();
      });
    } on RequestFailedException catch (e) {
      //
    }
  }

  List<OpenAIChatCompletionChoiceMessageModel> getChatHistoryMessages(
      List<MessageModel> messages,
      SessionModel currentSession,
      MessageModel userMessage) {
    List<OpenAIChatCompletionChoiceMessageModel> messages = [];
    messages.add(OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.system,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
              currentSession.prompt.content)
        ]));
    messages.add(OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.user,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
              userMessage.content)
        ]));
    return messages;
  }

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

import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
// import 'package:extended_image/extended_image.dart';
import 'package:geek_chat/controller/chat_message_controller.dart';
import 'package:geek_chat/controller/chat_session_controller.dart';
import 'package:geek_chat/controller/question_input_controller.dart';
import 'package:geek_chat/controller/settings_server_controller.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/models/session.dart';
import 'package:geek_chat/util/app_constants.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:geek_chat/util/geeker_ai_utils.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:uuid/uuid.dart';

class InputSubmitUtil {
  InputSubmitUtil._();

  static final InputSubmitUtil _instance = InputSubmitUtil._();
  static InputSubmitUtil get instance => _instance;

  final Logger logger = Get.find();

  Future<void> submitAzureChatModel(
    ChatMessageController chatMessageController,
    ChatSessionController chatSessionController,
    QuestionInputController questionInputController,
    SettingsServerController settingsServerController,
  ) async {
    logger.d("submitAzureChatModel");
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

    /// add quotes in the user message
    if (questionInputController.questionInputModel.quotedMessages.isNotEmpty) {
      userMessage.quotes = [];
      for (MessageModel msg
          in questionInputController.questionInputModel.quotedMessages) {
        userMessage.quotes!.add(msg.msgId);
      }
    }

    final client = OpenAIClient(
        baseUrl: settingsServerController.defaultServer
            .getRequestUrlForOpenaiDart(
                chatSessionController.currentSession.model),
        headers: {
          'api-key': settingsServerController.defaultServer
              .getApiKeyByModel(chatSessionController.currentSession.model)
        },
        queryParams: {
          'api-version': AppConstants.azureAPIVersion
        });
    try {
      final stream = client.createChatCompletionStream(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId(
              chatSessionController.currentSession.model),
          messages: getAzureRequestMessages(
              chatMessageController.messages,
              chatSessionController.currentSession,
              userMessage,
              questionInputController.questionInputModel.quotedMessages),
        ),
      );
      chatMessageController.addMessage(userMessage);
      chatMessageController.update();
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
      stream.listen((event) {
        logger.d("chat completion event: ${event.toString()} ");
        // final List<OpenAIChatCompletionChoiceMessageContentItemModel>? content =
        //     event.choices.first.delta.content;
        String? content = event.choices.first.delta.content;
        // targetMessage.content = content;
        if (content != null) {
          targetMessage.content = "${targetMessage.content}$content";
          targetMessage.streamContent = targetMessage.content;
        }
      }, onDone: () {
        targetMessage.generating = false;
        targetMessage.closeStream();
        chatMessageController.saveMessage(userMessage);
        chatMessageController.saveMessage(targetMessage);
        chatSessionController
            .updateSessionLastEdit(chatSessionController.currentSession);
        chatSessionController.update();
      }, onError: (e) {});
      // await for (final res in stream) {
      //   print(res.choices.first.delta.content);
      // }
    } catch (e) {
      logger.e("e");
      // TODO process exception
    }
  }

  List<ChatCompletionMessage> getAzureRequestMessages(
      List<MessageModel> historyMessages,
      SessionModel currentSession,
      MessageModel userMessage,
      [List<MessageModel>? quotedMessages]) {
    List<ChatCompletionMessage> messages = [];
    //// prompt
    List<OpenAIChatCompletionChoiceMessageModel> openaiRequestMessages =
        getChatRequestMessages(
            historyMessages, currentSession, userMessage, quotedMessages);
    OpenAIChatCompletionChoiceMessageModel promptMessage =
        openaiRequestMessages.first;
    messages.add(ChatCompletionMessage.system(
        content: getMessageContentText(promptMessage.content)));
    openaiRequestMessages.removeAt(0);
    for (OpenAIChatCompletionChoiceMessageModel item in openaiRequestMessages) {
      // messages.add(value)
      if (item.role == OpenAIChatMessageRole.user) {
        messages.add(ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(
                getMessageContentText(item.content))));
      } else if (item.role == OpenAIChatMessageRole.assistant) {
        messages.add(ChatCompletionMessage.assistant(
            content: getMessageContentText(item.content)));
      } else if (item.role == OpenAIChatMessageRole.function) {
        //
      } else if (item.role == OpenAIChatMessageRole.tool) {
        ///
      }
    }
    return messages;
  }

  String getMessageContentText(
      List<OpenAIChatCompletionChoiceMessageContentItemModel>? msgs) {
    String text = "";
    if (msgs != null) {
      for (OpenAIChatCompletionChoiceMessageContentItemModel item in msgs) {
        if (item.type == "text") {
          text = item.text!;
          break;
        }
      }
    }

    return text;
  }

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

    try {
      OpenAI openai = GeekerAIUtils.instance
          .getOpenaiInstance(settingsServerController.defaultServer);
      Stream<OpenAIStreamChatCompletionModel> chatCompletionStream =
          openai.chat.createStream(
        model: userMessage.model!,
        messages: getChatRequestMessages(
            chatMessageController.messages,
            chatSessionController.currentSession,
            userMessage,
            questionInputController.questionInputModel.quotedMessages),
        // toolChoice: "auto",
        temperature: chatSessionController.currentSession.temperature,
        // responseFormat: {"type": "json_object"},
        // user:
        // seed: 6, //https://platform.openai.com/docs/api-reference/chat/create
      );

      /// add quotes in the user message
      if (questionInputController
          .questionInputModel.quotedMessages.isNotEmpty) {
        userMessage.quotes = [];
        for (MessageModel msg
            in questionInputController.questionInputModel.quotedMessages) {
          userMessage.quotes!.add(msg.msgId);
        }
      }

      ///  将 Message 放到列表里, 这里要先计算 history messages再将 userMessage 加到sessions列表里
      chatMessageController.addMessage(userMessage);
      chatMessageController.update();

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
        targetMessage.closeStream();
        chatMessageController.saveMessage(userMessage);
        chatMessageController.saveMessage(targetMessage);
        chatSessionController
            .updateSessionLastEdit(chatSessionController.currentSession);
        chatSessionController.update();
      }, onError: (error) {
        logger.e("stream error: $error");
        targetMessage.content = error.message;
        // TODO process error.
      });
    } on RequestFailedException catch (e) {
      logger.e("error: $e");
      // TODO process exception
    } catch (e) {
      logger.e("getOpenAIInstance error: $e");
    }
  }

  List<OpenAIChatCompletionChoiceMessageModel> getChatRequestMessages(
      List<MessageModel> historyMessages,
      SessionModel currentSession,
      MessageModel userMessage,
      [List<MessageModel>? quotedMessages]) {
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

    /// 计算tokens
    int totalTokens = currentSession.maxContextSize -
        numTokenCounter(currentSession.model, currentSession.prompt.content);
    totalTokens = totalTokens -
        numTokenCounter(currentSession.model, userMessage.content);

    /// 最大历史消息数
    int totalMessageCount = currentSession.maxContextMsgCount;
    //TODO: 处理 quoted messsages
    if (quotedMessages != null && quotedMessages.isNotEmpty) {
      for (int i = 0; i < quotedMessages.length; i++) {
        MessageModel quoteMessage = quotedMessages[i];
        // for (MessageModel quoteMessage in quotedMessages) {
        messages.insert(
            1,
            OpenAIChatCompletionChoiceMessageModel(
                role: OpenAIChatMessageRole.user,
                content: [
                  OpenAIChatCompletionChoiceMessageContentItemModel.text(
                      quoteMessage.content)
                ]));
      }
      return messages;
    }

    for (MessageModel message in historyMessages) {
      totalTokens =
          totalTokens - numTokenCounter(currentSession.model, message.content);
      totalMessageCount -= 1;
      if (totalTokens < 0) {
        break;
      } else if (totalMessageCount <= 0 &&
          currentSession.maxContextMsgCount != 22) {
        /// 22 is unlimited count
        break;
      } else {
        // logger.d(OpenAIChatMessageRole.values
        //     .firstWhere((e) => e.name == message.role));
        messages.insert(
            1,
            OpenAIChatCompletionChoiceMessageModel(
                role: OpenAIChatMessageRole.values
                    .firstWhere((e) => e.name == message.role),
                content: [
                  OpenAIChatCompletionChoiceMessageContentItemModel.text(
                      message.content)
                ]));
      }
    }

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
      logger.e("getOpenAIInstance error: $e");
    }
  }

  Future<void> submitInput(
      ChatSessionController chatSessionController,
      ChatMessageController chatMessageController,
      SettingsServerController settingsServerController,
      QuestionInputController questionInputController) async {
    AiModel aiModel =
        AppConstants.getAiModel(chatSessionController.currentSession.model);
    if (settingsServerController.defaultServer.provider == "openai" ||
        settingsServerController.defaultServer.provider == "geekerchat") {
      if (aiModel.aiType == AiType.chatgpt) {
        if (chatSessionController.currentSession.modelType ==
            ModelType.image.name) {
          await InputSubmitUtil.instance.submitImageModel(
              chatMessageController,
              chatSessionController,
              questionInputController,
              settingsServerController);
        } else if (chatSessionController.currentSession.modelType ==
            ModelType.chat.name) {
          await InputSubmitUtil.instance.submitChatModel(
              chatMessageController,
              chatSessionController,
              questionInputController,
              settingsServerController);
        } else if (chatSessionController.currentSession.modelType ==
            ModelType.text.name) {
          // TODO process text model
        }
        questionInputController.clear();
        questionInputController.update();
      } else if (aiModel.aiType == AiType.bard) {
        logger.d("bard type");
      }
    } else if (settingsServerController.defaultServer.provider == "azure") {
      if (aiModel.aiType == AiType.chatgpt) {
        if (chatSessionController.currentSession.modelType ==
            ModelType.chat.name) {
          await InputSubmitUtil.instance.submitAzureChatModel(
              chatMessageController,
              chatSessionController,
              questionInputController,
              settingsServerController);
        }
        questionInputController.clear();
        questionInputController.update();
      }
    }
  }
}

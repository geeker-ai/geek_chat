import 'dart:convert';
// import 'dart:math';

import 'package:dart_openai/dart_openai.dart';
// import 'package:extended_image/extended_image.dart';
import 'package:geek_chat/controller/chat_message_controller.dart';
import 'package:geek_chat/controller/chat_session_controller.dart';
import 'package:geek_chat/controller/question_input_controller.dart';
import 'package:geek_chat/controller/settings_server_controller.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/models/server.dart';
import 'package:geek_chat/models/session.dart';
import 'package:geek_chat/util/app_constants.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:geek_chat/util/geeker_ai_utils.dart';
import 'package:get/get.dart';
import 'package:googleai_dart/googleai_dart.dart';
import 'package:logger/logger.dart';
// import 'package:openai_dart/openai_dart.dart';
import 'package:uuid/uuid.dart';
// import 'package:googleai_dart/googleai_dart.dart';
import 'package:langchain_google/langchain_google.dart';
import 'package:langchain/langchain.dart';
// import 'package:langchain_google/src/chat_models/chat_models.dart';

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
    String model = chatSessionController.currentSession.model;
    AiModel aiModel = AppConstants.getAiModel(model);

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

    if (aiModel.enableImage != null && aiModel.enableImage == true) {
      // userMessage.inputImageUrls.add(questionInputController.questionInputModel)
      if (questionInputController.questionInputModel.hasUploadImage) {
        userMessage.imageUrl =
            questionInputController.questionInputModel.uploadImage;
      }
    }

    try {
      // var openai = GeekerAIUtils.instance.getOpenaiInstance(
      //     settingsServerController.defaultServer,
      //     model: chatSessionController.currentSession.model);
      // var openai = null;
      late var openai;

      String deploymentId = "";
      String provider = settingsServerController.defaultServer.provider;
      logger.d("provider: $provider , $model");
      if (provider == "azure") {
        openai = GeekerAIUtils.instance.getAzureOpenaiInstance(
            settingsServerController.defaultServer, model);
        deploymentId = settingsServerController.defaultServer
            .getDeploymentIdByModel(model);
      } else {
        openai = GeekerAIUtils.instance
            .getOpenaiInstance(settingsServerController.defaultServer);
      }
      // int? maxTokens;
      // if (aiModel.modelType == ModelType.chat) {
      //   maxTokens = aiModel.maxTokens;
      // }
      Stream<OpenAIStreamChatCompletionModel> chatCompletionStream =
          openai.chat.createStream(
        model: provider == "azure" ? deploymentId : model,
        messages: getChatRequestMessages(
            chatMessageController.messages,
            chatSessionController.currentSession,
            userMessage,
            aiModel,
            questionInputController.questionInputModel.quotedMessages),
        // toolChoice: "auto",
        temperature: chatSessionController.currentSession.temperature,
        maxTokens: aiModel.maxTokens,
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
        updated: getCurrentDateTime() + 1,
        generating: true,
      );
      chatMessageController.addMessage(targetMessage);
      chatMessageController.update();
      chatCompletionStream.listen((event) {
        logger.d("chat completion event: ${event.toString()} ");
        if (event.choices.isNotEmpty) {
          final List<OpenAIChatCompletionChoiceMessageContentItemModel>?
              content = event.choices.first.delta.content;
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
        }
      }, onDone: () {
        logger.d("stream message is done");
        targetMessage.generating = false;
        targetMessage.closeStream();
        logger.d("user message: ${userMessage.imageUrls} ");
        chatMessageController.saveMessage(userMessage);
        targetMessage.updated = getCurrentDateTime() + 1;
        chatMessageController.saveMessage(targetMessage);
        chatSessionController
            .updateSessionLastEdit(chatSessionController.currentSession);
        chatSessionController.update();
      }, onError: (error) {
        logger.e("stream error: $error");
        targetMessage.content = "Error: ${error.message}";
        chatMessageController.update();
        targetMessage.closeStream();
        // TODO process error.
      });
    } on RequestFailedException catch (e) {
      logger.e("error: $e");
      // TODO process exception
    } on Exception catch (e) {
      logger.e("getOpenAIInstance error: $e");
    }
  }

  List<OpenAIChatCompletionChoiceMessageModel> getChatRequestMessages(
      List<MessageModel> historyMessages,
      SessionModel currentSession,
      MessageModel userMessage,
      AiModel aiModel,
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
              userMessage.content),
          if (aiModel.enableImage != null &&
              aiModel.enableImage == true &&
              userMessage.hasImage)
            OpenAIChatCompletionChoiceMessageContentItemModel.imageUrl(
                userMessage.imageUrl),
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
                  if (aiModel.enableImage != null &&
                      aiModel.enableImage == true &&
                      quoteMessage.hasImage)
                    OpenAIChatCompletionChoiceMessageContentItemModel.imageUrl(
                        quoteMessage.imageUrl),
                  OpenAIChatCompletionChoiceMessageContentItemModel.text(
                      quoteMessage.content),
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
                  if (aiModel.enableImage != null &&
                      aiModel.enableImage == true &&
                      message.hasImage)
                    OpenAIChatCompletionChoiceMessageContentItemModel.imageUrl(
                        message.imageUrl),
                  OpenAIChatCompletionChoiceMessageContentItemModel.text(
                      message.content),
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
    var openAI;
    String provider = settingsServerController.defaultServer.provider;
    String model = chatSessionController.currentSession.model;
    String deploymentId = "";
    try {
      chatMessageController.addMessage(userMessage);
      chatMessageController.update();
      if (provider == "azure") {
        openAI = GeekerAIUtils.instance.getAzureOpenaiInstance(
            settingsServerController.defaultServer, model);
        deploymentId = settingsServerController.defaultServer
            .getDeploymentIdByModel(model);
      } else {
        openAI = GeekerAIUtils.instance
            .getOpenaiInstance(settingsServerController.defaultServer);
      }

      OpenAIImageModel images = await openAI.image.create(
        model: provider == "azure" ? deploymentId : model,
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
        targetMessage.updated = getCurrentDateTime() + 1;
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

  errorHander(
      ChatSessionController chatSessionController,
      ChatMessageController chatMessageController,
      SettingsServerController settingsServerController,
      QuestionInputController questionInputController,
      String errorMsg) {
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

    chatMessageController.addMessage(userMessage);
    chatMessageController.update();

    MessageModel targetMessage = MessageModel(
      msgId: const Uuid().v4(),
      role: MessageRole.assistant.name,
      content: errorMsg,
      sId: chatSessionController.currentSession.sid,
      model: AppConstants.aiModels[0].modelName,
      msgType: 1,
      synced: false,
      generating: false,
      updated: getCurrentDateTime() + 5,
    );

    chatMessageController.addMessage(targetMessage);
    chatMessageController.update();
  }

  oldChatFunction(
      ChatSessionController chatSessionController,
      ChatMessageController chatMessageController,
      SettingsServerController settingsServerController,
      QuestionInputController questionInputController) async {
    chatMessageController.inputQuestion = questionInputController.inputText;
    // chatMessageController.quoteMessages =
    //     questionInputController.questionInputModel.quotedMessages;
    chatMessageController.submit(chatSessionController.currentSession.sid,
        onDone: () {
      chatMessageController.inputQuestion = "";
      chatSessionController
          .updateSessionLastEdit(chatSessionController.currentSession);
      chatSessionController.update();
    }, onError: () {});
  }

  submitGoogleModel(
      ChatSessionController chatSessionController,
      ChatMessageController chatMessageController,
      SettingsServerController settingsServerController,
      QuestionInputController questionInputController) async {
    String model = chatSessionController.currentSession.model;
    AiModel aiModel = AppConstants.getAiModel(model);

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

    /// add quotes in the user message
    if (questionInputController.questionInputModel.quotedMessages.isNotEmpty) {
      userMessage.quotes = [];
      for (MessageModel msg
          in questionInputController.questionInputModel.quotedMessages) {
        userMessage.quotes!.add(msg.msgId);
      }
    }

    Map<String, String>? headers;
    String? baseUrl;

    MessageModel targetMessage = MessageModel(
      msgId: const Uuid().v4(),
      role: MessageRole.assistant.name,
      content: "",
      sId: chatSessionController.currentSession.sid,
      model: chatSessionController.currentSession.model,
      msgType: 1,
      synced: false,
      updated: getCurrentDateTime() + 1,
      generating: false,
    );

    if (settingsServerController.defaultServer.provider == "geekerchat") {
      headers = {
        "Authorization":
            "Bearer ${settingsServerController.defaultServer.apiKey}"
      };
      baseUrl = "${settingsServerController.defaultServer.apiHost}/v1beta";
      // baseUrl = "http://localhost:3008/v1beta";
    }
    try {
      // final gemini = genai.GenerativeModel(model = aiModel.modelName);
      // final client = ChatGoogleGenerativeAI(
      //   apiKey: settingsServerController.defaultServer.apiKey,
      //   headers: headers,
      //   baseUrl: baseUrl,
      //   defaultOptions: ChatGoogleGenerativeAIOptions(
      //       model: aiModel.modelName, candidateCount: 1, maxOutputTokens: 8192),
      // );
      // final result = client
      //     .stream(PromptValue.chat([ChatMessage.humanText("讲一个故事，不少于400字")]));
      // result.listen((event) {
      //   logger.d("chunk: ${event}");
      // });
      // final result = await client.generate(getGoogleChatMessages(
      // final result = await client.generate(getGoogleChatMessages(
      //     chatMessageController.messages,
      //     chatSessionController.currentSession,
      //     userMessage,
      //     aiModel,
      //     questionInputController.questionInputModel.quotedMessages));
      // logger.d("result: $result");
      // logger.d(result.generations);
      // GoogleAIClient(apiKey: settingsServerController.defaultServer.apiKey);

      // targetMessage.content = result.generations.first.outputAsString;
      final client = GoogleAIClient(
          apiKey: settingsServerController.defaultServer.apiKey,
          baseUrl: "${settingsServerController.defaultServer.apiHost}/v1",
          headers: headers);
      final result = client.streamGenerateContent(
        modelId: aiModel.modelName,
        request: GenerateContentRequest(
            generationConfig: const GenerationConfig(
                candidateCount: 1, maxOutputTokens: 8192),
            contents: getGoogleChatContents(
                chatMessageController.messages,
                chatSessionController.currentSession,
                userMessage,
                aiModel,
                questionInputController.questionInputModel.quotedMessages)),
      );
      result.then((value) {
        logger.d("streamed response: $value");
      });
    } on Exception catch (e) {
      logger.e("submit google model error: $e");
      // targetMessage.content = e.toString();
    } finally {
      // chatMessageController.addMessage(userMessage);
      // chatMessageController.addMessage(targetMessage);
      // chatMessageController.saveMessage(userMessage);
      // chatMessageController.saveMessage(targetMessage);
      // chatSessionController
      //     .updateSessionLastEdit(chatSessionController.currentSession);
      // chatMessageController.update();
    }
  }

  List<Content> getGoogleChatContents(List<MessageModel> historyMessages,
      SessionModel currentSession, MessageModel userMessage, AiModel aiModel,
      [List<MessageModel>? quotedMessages]) {
    List<Content> contents = [];
    return contents;
  }

  List<ChatMessage> getGoogleChatMessages(List<MessageModel> historyMessages,
      SessionModel currentSession, MessageModel userMessage, AiModel aiModel,
      [List<MessageModel>? quotedMessages]) {
    List<ChatMessage> messages = [];
    int maxInputTokens = 20000; //32760;
    // messages.add(ChatMessage.humanText(currentSession.prompt.content));
    // messages.add(ChatMessage.humanText("Hi"));
    // messages.add(ChatMessage.ai("Hello! How can I assist you today?"));
    // messages.add(ChatMessage.humanText(userMessage.content));
    // if (historyMessages.isNotEmpty) {
    //   historyMessages.first.role != "user";
    //   historyMessages.removeAt(0);
    // }
    String nextRole = "user";
    String currentRole = "";
    maxInputTokens = maxInputTokens -
        numTokenCounter(aiModel.modelName, userMessage.content);

    String userMessageContent = userMessage.content;
    if (quotedMessages != null) {
      for (MessageModel message in quotedMessages) {
        userMessageContent = "${message.content} \n $userMessageContent";
      }
      messages.add(ChatMessage.humanText(userMessageContent));
      return messages;
    }
    int messageCount = 0;
    for (MessageModel message in historyMessages) {
      maxInputTokens =
          maxInputTokens - numTokenCounter(aiModel.modelName, message.content);
      if (maxInputTokens > 0 &&
          currentSession.maxContextMsgCount > messageCount) {
        if (message.role == nextRole) {
          if (nextRole == "user") {
            messages.add(ChatMessage.humanText(message.content));
            nextRole = "assistant";
            currentRole = "user";
          } else if (nextRole == "assistant") {
            messages.add(ChatMessage.ai(message.content));
            nextRole = "user";
            currentRole = "assistant";
          }
        }
        messageCount += 1;
      }
    }
    if (currentRole == "user" && messages.isNotEmpty) {
      messages.removeLast();
    }
    messages.add(ChatMessage.humanText(userMessageContent));
    // messages.add(ChatMessage.human(ChatMessageContent.text(currentSession.prompt.content)));
    return messages;
  }

  /// TODO 需重构, 使用server支持的模型定义来编写逻辑
  Future<void> submitInput(
      ChatSessionController chatSessionController,
      ChatMessageController chatMessageController,
      SettingsServerController settingsServerController,
      QuestionInputController questionInputController) async {
    logger.d(
        "call submitInput ${settingsServerController.defaultServer.provider}");
    AiModel aiModel =
        AppConstants.getAiModel(chatSessionController.currentSession.model);
    String provider = settingsServerController.defaultServer.provider;

    /// validate server configure
    if (settingsServerController.provider.isEmpty ||
        settingsServerController.defaultServer.getApiKey(aiModel).isEmpty ||
        settingsServerController.defaultServer
            .getBaseUrlByModel(aiModel.modelName)
            .isEmpty) {
      errorHander(
          chatSessionController,
          chatMessageController,
          settingsServerController,
          questionInputController,
          "The server configuration is incorrect.".tr);
      return;
    }

    logger.d("aitype: ${aiModel.aiType}");

    ProviderModel providerModel = AppConstants.getProvider(provider);
    if (providerModel.supportedModels.contains(aiModel.modelName)) {
      if (chatSessionController.currentSession.modelType ==
          ModelType.image.name) {
        await InputSubmitUtil.instance.submitImageModel(
            chatMessageController,
            chatSessionController,
            questionInputController,
            settingsServerController);
      } else if (chatSessionController.currentSession.modelType ==
          ModelType.chat.name) {
        if (aiModel.aiType == AiType.bard) {
          oldChatFunction(chatSessionController, chatMessageController,
              settingsServerController, questionInputController);
          return;
        } else if (aiModel.aiType == AiType.google) {
          await InputSubmitUtil.instance.submitGoogleModel(
              chatSessionController,
              chatMessageController,
              settingsServerController,
              questionInputController);
        } else {
          await InputSubmitUtil.instance.submitChatModel(
              chatMessageController,
              chatSessionController,
              questionInputController,
              settingsServerController);
        }
      } else if (chatSessionController.currentSession.modelType ==
          ModelType.text.name) {
        // TODO process text model
      } else {
        /// process error
        errorHander(
            chatSessionController,
            chatMessageController,
            settingsServerController,
            questionInputController,
            "The current server does not support this model. If you need to use all models, it is recommended to use the Geeker Chat server."
                .tr);
      }
      questionInputController.clear();
      questionInputController.update();
    } else {
      errorHander(
          chatSessionController,
          chatMessageController,
          settingsServerController,
          questionInputController,
          "The current server does not support this model. If you need to use all models, it is recommended to use the Geeker Chat server."
              .tr);
    }
  }
}

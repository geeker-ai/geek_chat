import 'dart:convert';

// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geek_chat/controller/chat_session_controller.dart';
import 'package:geek_chat/controller/locale_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/controller/settings_server_controller.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/models/session.dart';
import 'package:geek_chat/repository/sessions_repository.dart';
import 'package:geek_chat/service/openai_service.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class ChatMessageController extends GetxController {
  ChatSessionController chatSessionController =
      Get.find<ChatSessionController>();
  SettingsController settingsController = Get.find<SettingsController>();
  SettingsServerController settingsServerController = Get.find();
  final LocaleController localeController = Get.find();
  final SessionRepository _sessionRepository = Get.find<SessionRepository>();

  Logger logger = Get.find<Logger>();

  final List<MessageModel> _quoteMessages = [];

  List<MessageModel> get quoteMessages {
    return _quoteMessages;
  }

  set quoteMessages(List<MessageModel> messages) {
    _quoteMessages.addAll(messages);
  }

  void addQuoteMessage(MessageModel message) {
    if (!_quoteMessages.contains(message)) {
      _quoteMessages.add(message);
    }
  }

  void removeQuoteMessage(MessageModel message) {
    _quoteMessages.remove(message);
  }

  MessageModel createNewMessage(
      String sid, String role, String content, bool generating) {
    MessageModel mm = MessageModel(
        msgId: const Uuid().v4(),
        role: role,
        content: content,
        generating: generating);
    SessionModel? session = chatSessionController.getSessionBysid(sid);
    mm.model = session.model;
    mm.msgType = 1;
    mm.sId = sid;
    // mm.generating = generating;
    mm.synced = false;
    // mm.updated = int.parse(Moment.now().format('YYYYMMDDHHmmssSSS').toString());
    mm.updated = getCurrentDateTime();
    return mm;
  }

  List<MessageModel> messages = [];

  List<MessageModel> findBySessionId(String? sid) {
    messages.clear();
    _quoteMessages.clear();
    List<MessageTable> messageTables =
        _sessionRepository.findMessagesBySessionId(sid, 1);
    for (MessageTable mt in messageTables) {
      messages.add(MessageModel.fromMessageTable(mt));
    }
    if (messages.isEmpty) {
      // messages = getDefaultChatList();
    }
    return messages;
  }

  String inputQuestion = '';

  void submit(String sid,
      {required Function onDone, required Function onError}) {
    if (inputQuestion.isEmpty) {
      return;
    }
    MessageModel input = createNewMessage(const Uuid().v4(),
        settingsController.chatGPTRoles.user, inputQuestion, false);
    input.sId = sid;
    if (quoteMessages.isNotEmpty) {
      input.quotes = getQuotes();
    }
    logger.d("input: $input");
    messages.insert(0, input);
    inputQuestion = '';
    // _quoteMessages.clear;
    update();
    replyFromOpenAIWithSSE(input, sid, onDone: onDone, onError: onError);
  }

  void addMessage(MessageModel message) {
    messages.insert(0, message);
  }

  void saveMessage(MessageModel mm) {
    _sessionRepository.saveMessage(mm.toMessageTable());
  }

  void cleanSessionMessages(String sid) {
    if (messages.isEmpty) {
      findBySessionId(sid);
    }
    for (MessageModel message in messages) {
      _sessionRepository.removeMessage(message.msgId);
    }
    messages.clear();
  }

  void removeMessage(MessageModel message) {
    // _sessionRepository.remove(sid)
    messages.remove(message);
    _sessionRepository.removeMessage(message.msgId);
  }

  bool isMessagesTooLong(List<MessageModel> checkMessages) {
    if (checkMessages.isEmpty) {
      return false;
    }
    int tokenCount = 0;
    SessionModel currentSession = chatSessionController.currentSession;
    tokenCount =
        numTokenCounter(currentSession.model, currentSession.promptContent);
    if (inputQuestion.isNotEmpty) {
      tokenCount =
          tokenCount + numTokenCounter(currentSession.model, inputQuestion);
    }

    for (MessageModel message in checkMessages) {
      tokenCount = tokenCount +
          numTokenCounter(currentSession.model, message.content) +
          300;
    }
    if (tokenCount >= currentSession.maxContextSize) {
      return true;
    }

    return false;
  }

  Future<List<Map<String, String>>> getRequestMessages(
      MessageModel input) async {
    SessionModel currentSession = chatSessionController.currentSession;
    var requestMessages = [
      {"role": "system", "content": currentSession.promptContent},
    ];
    int tokenCount = 0;
    tokenCount =
        numTokenCounter(currentSession.model, currentSession.promptContent);
    tokenCount =
        tokenCount + numTokenCounter(currentSession.model, input.content);
    logger.d("count message: ${messages.length}");
    int i = 0;
    List<MessageModel> localMessages;
    if (quoteMessages.isEmpty) {
      localMessages = messages;
    } else {
      localMessages = quoteMessages;
    }
    for (MessageModel message in localMessages) {
      /// 控制每次会话关联的历史消息数量
      if (i >= currentSession.maxContextMsgCount) {
        break;
      }
      tokenCount = tokenCount +
          numTokenCounter(currentSession.model, message.content) +
          200;
      if (tokenCount > currentSession.maxContextSize) {
        break;
      }
      requestMessages
          .insert(1, {"role": message.role, "content": message.content});
      // requestMessages.add({"role": message.role, "content": message.content});
      i++;
    }
    requestMessages.add({"role": input.role, "content": input.content});
    logger.d("request messages length: ${requestMessages.length}");
    logger.d(
        "total token count: $tokenCount, model token count: ${currentSession.maxContextSize}");
    return requestMessages;
  }

  List<String> getQuotes() {
    List<String> quoteIds = [];
    for (MessageModel mm in quoteMessages) {
      if (!quoteIds.contains(mm.msgId)) {
        quoteIds.add(mm.msgId);
      }
    }
    return quoteIds;
  }

  void replyFromOpenAIWithSSE(MessageModel input, String sid,
      {required Function onDone, required Function onError}) async {
    SessionModel currentSession = chatSessionController.currentSession;
    MessageModel targetMessage = createNewMessage(
        const Uuid().v4(), settingsController.chatGPTRoles.assistant, '', true);
    targetMessage.sId = sid;
    var chatMessage = {
      "model": currentSession.model,
      "stream": true,
      "messages": await getRequestMessages(input)
    };

    // String url = "";

    logger.d(chatMessage);
    _quoteMessages.clear();
    update();
    messages.insert(0, targetMessage);
    update();
    // var headers = {"": ""};
    // if (settingsServerController.defaultServer.provider == "azure") {
    //   url =
    //       "${settingsServerController.defaultServer.apiHost}/openai/deployments/${settingsServerController.defaultServer.deploymentId}/chat/completions?api-version=2023-05-15";
    //   headers = {
    //     'Accept': 'text/event-stream',
    //     'Cache-Control': 'no-cache',
    //     'api-key': settingsServerController.defaultServer.apiKey,
    //     'Content-Type': 'application/json',
    //     'Accept-Language': settingsController.lang
    //   };
    // } else {
    //   url =
    //       "${settingsServerController.defaultServer.apiHost}/v1/chat/completions";
    //   headers = {
    //     'Accept': 'text/event-stream',
    //     'Cache-Control': 'no-cache',
    //     'Authorization':
    //         'Bearer ${settingsServerController.defaultServer.apiKey}',
    //     'Content-Type': 'application/json',
    //     'Accept-Language': settingsController.lang
    //   };
    // }
    // String url = settingsServerController.defaultServer
    //     .getRequestURL(currentSession.model);
    // url = "https://api2.fucklina.com/v1/chat/completions";
    AiModel model = settingsController.getModelByName(currentSession.model);
    String url =
        settingsServerController.defaultServer.getRequestURLByModel(model);
    // url = "https://api2.fucklina.com/v1/chat/completions";
    Map<String, String> headers =
        settingsServerController.defaultServer.getRequestHeaders(model);
    headers['Accept-Language'] = localeController.locale.id;
    logger.d("url: $url");
    logger.d(headers);
    int debounce = 7;
    if (model.aiType == AiType.bard) {
      debounce = 15;
    }
    Stream openai = SSEClient.subscribeToSSE(
      url: url,
      headers: headers,
      body: chatMessage,
      debounce: Duration(milliseconds: debounce),
    );

    openai.listen(
      (event) async {
        if (true) {
          try {
            // logger.d("before json decode: ${event.trim()}");
            if ("$event".trim() != "[DONE]" && "$event".isNotEmpty) {
              var data = jsonDecode(event);
              String content = "${data['choices'][0]['delta']['content']}";
              String fullText = content == "null" ? "" : content;
              // logger.d("${data['choices'][0]['delta']}");
              // logger.d("message: $content");

              targetMessage.content = "${targetMessage.content}$fullText";
              if (targetMessage.generating == true) {
                targetMessage.streamContent = targetMessage.content;
              }
            }
          } catch (e, s) {
            logger.e("error: $e, $s");
            if (targetMessage.generating == true) {
              targetMessage.content = "${targetMessage.content} $e";
              targetMessage.streamContent = targetMessage.content;
              targetMessage.closeStream();
              update();
            }
          }
        }
      },
      onError: (e, s) {
        targetMessage.content = e;
        targetMessage.streamContent = targetMessage.content;
        logger.d("Error: $e");
        targetMessage.closeStream();
        update();
        onError();
      },
      onDone: () {
        logger.d("done ------------------- ");
        saveMessage(input);
        targetMessage.updated = getCurrentDateTime(); // Update lastupdated
        saveMessage(targetMessage);
        if (targetMessage.generating == true) {
          targetMessage.closeStream();
          update();
        }
        onDone();
      },
    );
  }

  List<MessageModel> getDefaultChatList() {
    String sid = 'c9518d4b-fdd1-4826-b783-fc1ba4f4b83b';
    List<MessageModel> messageList = [];
    String s2 = "Hi there! How can I assist you today?";
    MessageModel m2 = createNewMessage(
        sid, settingsController.chatGPTRoles.assistant, s2, false);
    messageList.add(m2);

    String s1 = "Hi";
    MessageModel mm =
        createNewMessage(sid, settingsController.chatGPTRoles.user, s1, false);
    messageList.add(mm);
    return messageList;
  }

  MessageModel? findMessageBymid(String mid) {
    MessageTable? mt = _sessionRepository.findMessageBymid(mid);
    MessageModel? mm;

    if (mt != null) {
      mm = MessageModel.fromMessageTable(mt);
    }
    return mm;
  }

  List<MessageModel> findQuoteMessages(MessageModel message) {
    List<MessageModel> quotes = [];
    if (message.quotes == null) {
      return quotes;
    }

    for (String mid in message.quotes!) {
      MessageModel? mm = findMessageBymid(mid);
      if (mm != null) {
        quotes.add(mm);
      }
    }
    return quotes;
  }
}

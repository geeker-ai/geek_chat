// import 'dart:io';

import 'dart:convert';

// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geek_chat/controller/chat_list_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/session.dart';
import 'package:geek_chat/repository/sessions_repository.dart';
import 'package:geek_chat/service/openai_service.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:uuid/uuid.dart';

class ChatMessageController extends GetxController {
  ChatListController chatListController = Get.find<ChatListController>();
  SettingsController settingsController = Get.find<SettingsController>();
  final SessionRepository _sessionRepository = Get.find<SessionRepository>();

  Logger logger = Get.find<Logger>();

  MessageModel createNewMessage(
      String sid, String role, String content, bool generating) {
    MessageModel mm = MessageModel(
        msgId: const Uuid().v4(),
        role: role,
        content: content,
        generating: generating);
    SessionModel? session = chatListController.getSessionBysid(sid);
    mm.model = session.model;
    mm.msgType = 1;
    // mm.generating = generating;
    mm.synced = false;
    mm.updated = int.parse(Moment.now().format('YYYYMMDDHHmmssSSS').toString());
    return mm;
  }

  List<MessageModel> messages = [];

  List<MessageModel> findBySessionId(String? sid) {
    messages.clear();
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

  void submit(String sid) {
    MessageModel input = createNewMessage(const Uuid().v4(),
        settingsController.chatGPTRoles.user, inputQuestion, false);
    input.sId = sid;
    messages.insert(0, input);
    inputQuestion = '';
    update();
    replyFromOpenAIWithSSE(input, sid);
  }

  void saveMessage(MessageModel mm) {
    _sessionRepository.saveMessage(mm.toMessageTable());
  }

  void cleanSessionMessages(String sid) {
    // _sessionRepository
    for (MessageModel message in messages) {
      // logger.d("message: ${message.msgId}");
      // removeMessage(message);
      _sessionRepository.removeMessage(message.msgId);
    }
    messages.clear();
  }

  void removeMessage(MessageModel message) {
    // _sessionRepository.remove(sid)
    messages.remove(message);
    _sessionRepository.removeMessage(message.msgId);
  }

  Future<List<Map<String, String>>> getRequestMessages(
      MessageModel input) async {
    SessionModel currentSession = chatListController.currentSession;
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
    for (MessageModel message in messages) {
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
      requestMessages.add({"role": message.role, "content": message.content});
      i++;
    }
    requestMessages.add({"role": input.role, "content": input.content});
    logger.d("request messages length: ${requestMessages.length}");
    logger.d(
        "total token count: $tokenCount, model token count: ${currentSession.maxContextSize}");
    return requestMessages;
  }

  void replyFromOpenAIWithSSE(MessageModel input, String sid) async {
    SessionModel currentSession = chatListController.currentSession;
    MessageModel targetMessage = createNewMessage(
        const Uuid().v4(), settingsController.chatGPTRoles.assistant, '', true);
    targetMessage.sId = sid;
    var chatMessage = {
      "model": currentSession.model,
      "stream": true,
      "messages": await getRequestMessages(input)
    };
    messages.insert(0, targetMessage);
    update();
    var headers = {
      'Accept': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Authorization': 'Bearer ${settingsController.apiKey}',
      'Content-Type': 'application/json',
      'Accept-Language': settingsController.settings.language
    };
    logger.d(headers);

    Stream openai = SSEClient.subscribeToSSE(
      url: "${settingsController.apiHost}/v1/chat/completions",
      headers: headers,
      body: chatMessage,
      debounce: const Duration(milliseconds: 20),
    );

    openai.listen(
      (event) async {
        if (true) {
          try {
            var data = jsonDecode(event);
            String content = "${data['choices'][0]['delta']['content']}";
            if (content.trim() != 'null') {
              targetMessage.content = "${targetMessage.content}$content";
              if (targetMessage.generating == true) {
                targetMessage.streamContent = targetMessage.content;
              }
            }
          } catch (e, s) {
            logger.e("error: $e, $s");
            if (targetMessage.generating == true) {
              targetMessage.content = "${targetMessage.content} $e";
              targetMessage.streamContent = targetMessage.content;
            }
          }
        }
      },
      onError: (e, s) {
        targetMessage.content = e;
        targetMessage.streamContent = targetMessage.content;
        logger.d("Error: $e");
      },
      onDone: () {
        logger.d("done ------------------- ");
        saveMessage(input);
        saveMessage(targetMessage);
        if (targetMessage.generating == true) {
          targetMessage.contentStream!.close();
          targetMessage.generating = false;
          update();
        }
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
}

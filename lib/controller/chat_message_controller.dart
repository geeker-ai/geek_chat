// import 'dart:io';

import 'dart:convert';

import 'package:flutter_gpt_tokenizer/flutter_gpt_tokenizer.dart';
import 'package:geek_chat/controller/chat_list_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/session.dart';
import 'package:geek_chat/repository/sessions_repository.dart';
import 'package:geek_chat/service/openai_service.dart';
import 'package:get/get.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:uuid/uuid.dart';

class ChatMessageController extends GetxController {
  ChatListController chatListController = Get.find<ChatListController>();
  SettingsController settingsController = Get.find<SettingsController>();
  final SessionRepository _sessionRepository = Get.find<SessionRepository>();
  // late OpenAIService openAIService;

  @override
  void onInit() {
    super.onInit();
    // openAIService = Get.put(OpenAIService());
    // openAIService = Get.putAsync(() => OpenAIService());
    Get.put(Tokenizer());
  }

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
      messages = getDefaultChatList();
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
    // _sessionRepository.saveMessage(input.toMessageTable());
    update();
    replyFromOpenAIWithSSE(input, sid);
  }

  void saveMessage(MessageModel mm) {
    _sessionRepository.saveMessage(mm.toMessageTable());
  }

  Future<List<Map<String, String>>> getRequestMessages(
      MessageModel input) async {
    SessionModel currentSession = chatListController.currentSession;
    Tokenizer tokenizer = Get.find<Tokenizer>();
    var requestMessages = [
      {"role": "system", "content": currentSession.promptContent},
    ];
    int tokenCount = 0;
    tokenCount = await tokenizer.count(currentSession.promptContent,
        modelName: currentSession.model);
    tokenCount = tokenCount +
        await tokenizer.count(input.content, modelName: currentSession.model);
    print("count message: ${messages.length}");
    for (MessageModel message in messages) {
      // print("message id: ${message.updated}");
      tokenCount = tokenCount +
          await tokenizer.count(message.content,
              modelName: currentSession.model) +
          200;
      if (tokenCount > currentSession.maxContextSize) {
        break;
      }
      requestMessages.add({"role": message.role, "content": message.content});
    }
    requestMessages.add({"role": input.role, "content": input.content});
    print("request messages length: ${requestMessages.length}");
    print(
        "total token count: $tokenCount, model token count: ${currentSession.maxContextSize}");
    return requestMessages;
  }

  void replyFromOpenAIWithSSE(MessageModel input, String sid) async {
    SessionModel currentSession = chatListController.currentSession;
    MessageModel targetMessage = createNewMessage(const Uuid().v4(),
        settingsController.chatGPTRoles.assistant, '...', true);
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
      // 'Accept-Language': settingsController.locale
    };

    Stream openai = SSEClient.subscribeToSSE(
      url: "${settingsController.apiHost}/v1/chat/completions",
      headers: headers,
      body: chatMessage,
      debounce: const Duration(milliseconds: 20),
    );

    openai.listen(
      (event) async {
        if (targetMessage.content == '...') {
          targetMessage.content = '';
        }
        if (event.isNotEmpty) {
          try {
            var data = jsonDecode(event);
            // String model = "${data['model']}";
            String content = "${data['choices'][0]['delta']['content']}";
            // String finished = "${data['choices'][0]['finish_reason']}".trim();
            if (content.trim().isNotEmpty && content.trim() != 'null') {
              // print(content);
              targetMessage.content = "${targetMessage.content}$content";
              if (targetMessage.generating == true) {
                targetMessage.streamContent = targetMessage.content;
              }
            }
          } catch (e, s) {
            print("error: $e, $s");
          }
        }
      },
      onDone: () {
        // print("doen ------------------- ");
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
    //c9518d4b-fdd1-4826-b783-fc1ba4f4b83b
    String sid = 'c9518d4b-fdd1-4826-b783-fc1ba4f4b83b';
    List<MessageModel> messageList = [];
    String s2 = """
这个错误通常是由于在将 Flask SQLAlchemy 的 `db` 对象初始化时，将 `current_app` 作为参数传递给 `db.init()` 函数，而 `current_app` 是一个 `LocalProxy` 对象，无法直接使用 `weakref` 创建弱引用。
为了解决这个问题，您可以尝试将 `current_app._get_current_object()` 作为参数传递给 `db.init()`，而不是直接使用 `current_app` 对象。修改后的代码如下所示：

```python
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
db = SQLAlchemy()

# 初始化 SQLAlchemy
with app.app_context():
    db.init_app(current_app._get_current_object())
```

通过调用 `current_app._get_current_object()`，您可以获取到实际的 `Flask` 应用对象，从而避免了对 `LocalProxy` 对象进行弱引用的问题。

请注意，上述代码中我使用了 `with app.app_context():` 来确保在初始化 SQLAlchemy 之前应用程序上下文已经被推送。这是因为在 Flask 中，访问 `current_app` 对象之前需要确保应用程序上下文已经被激活。

希望这可以解决您的问题！如果您还有其他疑问，请随时提问。
    """;
    MessageModel m2 = createNewMessage(
        sid, settingsController.chatGPTRoles.assistant, s2, false);
    messageList.add(m2);

    String s1 = """
flask 在 db.init(current_app)中报这样的错误 TypeError: cannot create weak reference to 'LocalProxy' object
    """;
    MessageModel mm =
        createNewMessage(sid, settingsController.chatGPTRoles.user, s1, false);
    messageList.add(mm);
    return messageList;
  }
}

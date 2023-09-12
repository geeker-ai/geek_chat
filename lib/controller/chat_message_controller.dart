import 'dart:io';

import 'package:geek_chat/controller/chat_list_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/session.dart';
import 'package:geek_chat/repository/sessions_repository.dart';
import 'package:get/get.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:uuid/uuid.dart';

class ChatMessageController extends GetxController {
  ChatListController chatListController = Get.find<ChatListController>();
  SettingsController settingsController = Get.find<SettingsController>();
  final SessionRepository _sessionRepository = Get.find<SessionRepository>();

  @override
  void onInit() {
    super.onInit();
  }

  MessageModel createNewMessage(
      String sid, String role, String content, bool generating) {
    MessageModel mm =
        MessageModel(msgId: const Uuid().v4(), role: role, content: content);
    SessionModel session = chatListController.getSessionBysid(sid);
    mm.model = session.model;
    mm.msgType = 1;
    mm.generating = generating;
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

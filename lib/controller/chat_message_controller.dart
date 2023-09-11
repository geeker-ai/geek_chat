import 'package:geek_chat/controller/chat_list_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/session.dart';
import 'package:geek_chat/repository/message_repository.dart';
import 'package:get/get.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:uuid/uuid.dart';

class ChatMessageController extends GetxController {
  ChatListController chatListController = Get.find<ChatListController>();
  MessageRepository messageRepository =
      MessageRepository(SettingsController.to.dataDir);

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

  List<MessageModel> findBySessionId(String sid) {
    messages.clear();
    List<MessageTable> messageTables =
        messageRepository.findBySessionId(sid, 1);
    for (MessageTable mt in messageTables) {
      messages.add(MessageModel.fromMessageTable(mt));
    }
    return messages;
  }
}

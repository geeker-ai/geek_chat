import 'dart:io';

import 'package:isar/isar.dart';

part 'message_repository.g.dart';

@collection
class MessageTable {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String? mid;

  @Index(composite: [CompositeIndex('status')])
  String? sid;

  String? model;
  String? role;
  String? content;
  int? updated; // 最后更新时间 YYYYMMDDHHmmssSSS
  // bool? generating;
  // String msgType = 'new'; // new, refresh
  bool synced = false; //

  @Index()
  int status = 1; // 1 = show, 0 = delete
}

class MessageRepository {
  late Directory dir;
  late Isar isar;

  MessageRepository(this.dir) {
    isar = Isar.openSync([MessageTableSchema], directory: dir.path);
  }

  List<MessageTable> findBySessionId(String sid, int status) {
    List<MessageTable> messageList;
    messageList = isar.messageTables
        .where()
        .sidStatusEqualTo(sid, status)
        .sortByUpdatedDesc()
        .findAllSync();
    return messageList;
  }

  List<MessageTable> findAll(int status) {
    List<MessageTable> messageList;
    messageList = isar.messageTables
        .where()
        .statusEqualTo(status)
        .sortByUpdated()
        .findAllSync();
    return messageList;
  }

  MessageTable? findMessageBymid(String? mid) {
    MessageTable? mt;
    mt = isar.messageTables.where().midEqualTo(mid).findFirstSync();
    return mt;
  }

  int save(MessageTable mt) {
    MessageTable? mtInDb = findMessageBymid(mt.mid);
    MessageTable savedmt = mt;
    if (mtInDb != null && mtInDb.id > 0) {
      savedmt.id = mtInDb.id;
    }
    return isar.writeTxnSync(() => isar.messageTables.putSync(savedmt));
  }
}

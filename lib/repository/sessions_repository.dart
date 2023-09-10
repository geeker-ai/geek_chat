import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// part 'chat';
part 'sessions_repository.g.dart';

@collection
class SessionTable {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String sid = '';

  String? name;
  // Message? prompt
  String? promptContent;

  @Index(composite: [CompositeIndex('status'), CompositeIndex('updated')])
  String type = 'chatgpt'; // chatgpt / bard

  @Index(composite: [CompositeIndex('status'), CompositeIndex('updated')])
  String modelType = 'chat'; // chat / text / image

  String model = 'gpt-3.5-turbo';
  int? maxContextSize;
  int? maxContextMsgCount;
  double? temperature;
  int? maxTokens;
  bool synced = false;

  @Index(composite: [CompositeIndex('updated')])
  int status = 1; // 1 = show, 0 = delete
  int? updated; // 最后更新时间 YYYYMMDDHHmmssSSS
}

class SessionRepository {
  late Directory dir;
  late Isar isar;

  // SessionRepository._internal();
  // static late SessionRepository _instance;
  // static Future<SessionRepository> getInstance() async {
  //   // ignore: unnecessary_null_comparison
  //   if (_instance == null) {
  //     _instance = SessionRepository._internal();
  //     await _instance.initSession();
  //   }
  //   return _instance;
  // }

  SessionRepository(this.dir) {
    isar = Isar.openSync([SessionTableSchema], directory: dir.path);
  }

  // initSession() async {
  //   dir = await getApplicationDocumentsDirectory();
  //   isar = Isar.openSync([SessionTableSchema], directory: dir.path);
  // }

  int save(SessionTable session) {
    SessionTable? st = findBySessionId(session.sid);
    SessionTable st2 = session;
    if (st != null) {
      st2.id = st.id;
    }
    print(st2.updated);
    return isar.writeTxnSync(() => isar.sessionTables.putSync(st2));
  }

  List<SessionTable> findAll(int status) {
    List<SessionTable> chatList;
    chatList = isar.sessionTables
        .where()
        .statusEqualToAnyUpdated(status)
        .sortByUpdatedDesc()
        .findAllSync();
    return chatList;
  }

  void remove(String sid) {
    SessionTable? st = findBySessionId(sid);
    if (st != null) {
      st.status = 0;
      save(st);
    }
  }

  SessionTable? findBySessionId(String sid) {
    SessionTable? st;
    st = isar.sessionTables.where().sidEqualTo(sid).findFirstSync();
    return st;
  }

  SessionTable? findFirst() {
    SessionTable? st;
    st = isar.sessionTables.where().statusEqualToAnyUpdated(1).findFirstSync();
    return st;
  }

  bool isExist(String sid) {
    int count = isar.sessionTables.where().sidEqualTo(sid).countSync();
    if (count > 0) {
      return true;
    }
    return false;
  }
}

import 'package:isar/isar.dart';

part 'message_repository.g.dart';

@collection
class MessageTable {
  Id id = Isar.autoIncrement;
  String? mid;
  String? sid;
  String? model;
  String? role;
  String? content;
  int? updated; // 最后更新时间 YYYYMMDDHHmmssSSS
  bool? generating;
  String msgType = 'new'; // new, refresh
  bool synced = false; //
  int status = 1; // 1 = show, 0 = delete

  void cancel() {
    //
  }
}

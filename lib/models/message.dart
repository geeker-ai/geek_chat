import 'dart:async';

import 'package:geek_chat/repository/sessions_repository.dart';

class MessageModel {
  String msgId;
  String? sId;
  String? model;
  String role;
  String content;
  int? updated;
  bool? generating;
  int? msgType; // 1=new, 2=refresh
  bool? synced;
  int? status; // 1 = show, 2=delete
  StreamController<String>? contentStream;

  MessageModel(
      {required this.msgId,
      required this.role,
      required this.content,
      this.sId,
      this.model,
      this.updated,
      this.generating,
      this.msgType,
      this.synced,
      this.status}) {
    if (generating == true) {
      // print("contentStream = StreamController<String>();");
      contentStream = StreamController<String>();
      streamContent = content;
    }
  }
  //: this.updated = int.parse(Moment.now().format('YYYYMMDDHHmmssSSS').toString())

  factory MessageModel.fromMessageTable(MessageTable mt) {
    MessageModel mm = MessageModel(
      msgId: mt.mid ?? '',
      role: mt.role ?? '',
      content: mt.content ?? '',
    );
    mm.sId = mt.sid;
    mm.model = mt.model;
    mm.updated = mt.updated;
    mm.generating = false;
    mm.synced = mt.synced;
    mm.status = mt.status;
    return mm;
  }

  set streamContent(String word) {
    if (contentStream != null) {
      contentStream!.add(word);
      // content = "${content}${word}";
    }
  }

  MessageTable toMessageTable() {
    MessageTable mt = MessageTable();
    mt.mid = msgId;
    mt.sid = sId;
    mt.model = model;
    mt.role = role;
    mt.content = content;
    mt.updated = updated;
    mt.synced = synced ?? false;
    mt.status = status ?? 1;
    return mt;
  }
}

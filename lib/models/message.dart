import 'dart:async';
import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
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
  List<String>? quotes;
  StreamController<String>? contentStream;

  String? postJson;
  String? responseJson;

  MessageModel({
    required this.msgId,
    required this.role,
    required this.content,
    this.sId,
    this.model,
    this.updated,
    this.generating,
    this.msgType,
    this.synced,
    this.status,
    this.quotes,
    this.postJson,
    this.responseJson,
  }) {
    if (generating == true) {
      // print("contentStream = StreamController<String>();");
      contentStream = StreamController<String>();
      streamContent = content;
    }
  }
  //: this.updated = int.parse(Moment.now().format('YYYYMMDDHHmmssSSS').toString())

  OpenAIImageModel? get openAIImageModel {
    if (role == "user") {
      return null;
    }
    if (responseJson == null) {
      return null;
    }
    // print("openai response json: $responseJson");
    return OpenAIImageModel.fromMap(
        jsonDecode(responseJson!) as Map<String, dynamic>);
  }

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
    if (mt.quotes != null) {
      mm.quotes = mt.quotes;
    }
    if (mt.postJson != null) {
      mm.postJson = mt.postJson;
    }
    if (mt.responseJson != null) {
      mm.responseJson = mt.responseJson;
    }
    return mm;
  }

  set streamContent(String word) {
    if (contentStream != null) {
      contentStream!.add(word);
      // content = "${content}${word}";
    }
  }

  closeStream() {
    if (contentStream != null) {
      contentStream!.close();
      generating = false;
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
    if (quotes != null) {
      mt.quotes = quotes;
    }
    if (postJson != null) {
      mt.postJson = postJson;
    }
    if (responseJson != null) {
      mt.responseJson = responseJson;
    }
    return mt;
  }
}

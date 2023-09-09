import 'package:geek_chat/repository/sessions_repository.dart';

class SessionModel {
  //
  String sid;
  String name;
  String promptContent;
  String type;
  String modelType;
  String model;
  int maxContextSize;
  int maxContextMsgCount;
  double temperature;
  int maxTokens;
  int updated;
  bool synced;
  int status; // 1 = show, 0 = delete

  SessionModel({
    required this.sid,
    required this.name,
    required this.promptContent,
    required this.type,
    required this.modelType,
    required this.model,
    required this.maxContextSize,
    required this.maxContextMsgCount,
    required this.temperature,
    required this.maxTokens,
    required this.updated,
    required this.synced,
    required this.status,
  });

  factory SessionModel.fromTable(SessionTable session) {
    return SessionModel(
        sid: session.sid,
        name: session.name ?? '',
        promptContent: session.promptContent ?? '',
        type: session.type,
        modelType: session.modelType,
        model: session.model,
        maxContextSize: session.maxContextSize ?? 0,
        maxContextMsgCount: session.maxContextMsgCount ?? 0,
        temperature: session.temperature ?? 0.1,
        maxTokens: session.maxTokens ?? 1024,
        updated: session.updated ?? 0,
        synced: session.synced,
        status: session.status);
  }
}

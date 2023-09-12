import 'dart:io';

import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/models/session.dart';
import 'package:geek_chat/repository/sessions_repository.dart';
import 'package:get/get.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:uuid/uuid.dart';

class ChatListController extends GetxController {
  List<SessionModel> sessions = [];

  late SessionModel currentSession;

  final SessionRepository _sessionRepository = Get.find<SessionRepository>();

  ChatListController() {
    // _sessionRepository = SessionRepository.getInstance();
    // Directory dir = SettingsController.to.dataDir;
    // _sessionRepository = SessionRepository(dir);
  }

  @override
  void onInit() {
    super.onInit();
    reloadSessions();
  }

  void reloadSessions() {
    sessions.clear();
    List<SessionTable> sessionTables = _sessionRepository.findAll(1);
    for (SessionTable st in sessionTables) {
      sessions.add(SessionModel.fromTable(st));
    }
  }

  SessionModel createNewSession() {
    AiModel model = SettingsController.to.getModelByName('gpt-3.5-turbo');
    currentSession = SessionModel(
        sid: const Uuid().v4(),
        name: 'Untitled',
        promptContent: 'You are a helpful assistant.',
        type: model.aiType.name,
        modelType: model.modelType.name,
        model: model.modelName,
        maxContextSize: model.maxContextSize,
        maxContextMsgCount: 22,
        temperature: model.temperature,
        maxTokens: model.maxTokens,
        updated: int.parse(Moment.now()
            .format("YYYYMMDDHHmmssSSS")
            .toString()), // TODO updated
        synced: false,
        status: 1);
    return currentSession;
  }

  SessionModel getSessionBysid(String? sid) {
    late SessionTable? st;
    if (sid != null && sid.isNotEmpty) {
      st = _sessionRepository.findBySessionId(sid);
    } else {
      st = _sessionRepository.findFirst();
    }
    if (st != null) {
      currentSession = SessionModel.fromTable(st);
    }
    return currentSession;
  }

  void save() {
    _sessionRepository.save(currentSession.toSessionTable());
    getSessionBysid(currentSession.sid);
  }

  void remove(String sid) {
    _sessionRepository.remove(sid);
  }
}

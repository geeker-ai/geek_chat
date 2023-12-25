// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/models/session.dart';
import 'package:geek_chat/repository/sessions_repository.dart';
import 'package:geek_chat/util/app_constants.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:get/get.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:uuid/uuid.dart';

class ChatListScrollToolController extends GetxController {
  final GlobalKey anchroKey = GlobalKey();
  late double dx, dy;
}

class ChatSessionController extends GetxController {
  List<SessionModel> sessions = [];

  late SessionModel currentSession;
  String currentSessionId = '';

  final SessionRepository _sessionRepository = Get.find<SessionRepository>();

  ChatSessionController() {
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
    if (sessions.isNotEmpty) {
      currentSession = sessions.first;
      currentSessionId = currentSession.sid;
    }
  }

  set currentModelName(String modelName) {
    AiModel model = AppConstants.getAiModel(modelName);
    currentSession.model = model.modelName;
    currentSession.modelType = model.modelType.name;
    currentSession.maxContextSize = model.maxContextSize;
    currentSession.maxTokens = model.maxTokens ?? 0;
  }

  @Deprecated("message")
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
        maxTokens: model.maxTokens ?? 0,
        updated: int.parse(Moment.now()
            .format("YYYYMMDDHHmmssSSS")
            .toString()), // TODO updated
        synced: false,
        status: 1);
    currentSessionId = currentSession.sid;
    return currentSession;
  }

  SessionModel newSession(
      {String name = 'Untitled',
      String prompt = 'You are a helpful assistant.',
      String modelName = 'gpt-3.5-turbo'}) {
    AiModel model = AppConstants.getAiModel(modelName);
    return SessionModel(
        sid: const Uuid().v4(),
        name: name,
        promptContent: prompt,
        type: model.aiType.name,
        modelType: model.modelType.name,
        model: model.modelName,
        maxContextSize: model.maxContextSize,
        maxContextMsgCount: model.maxContextMsgCount ?? 22,
        temperature: model.temperature,
        maxTokens: model.maxTokens ?? 0,
        updated: getCurrentDateTime(),
        synced: false,
        status: 1);
  }

  @Deprecated("message")
  SessionModel createSession(
      {String name = 'Untitled',
      String prompt = 'You are a helpful assistant.'}) {
    AiModel model = SettingsController.to.getModelByName('gpt-3.5-turbo');
    currentSession = SessionModel(
        sid: const Uuid().v4(),
        name: name,
        promptContent: prompt,
        type: model.aiType.name,
        modelType: model.modelType.name,
        model: model.modelName,
        maxContextSize: model.maxContextSize,
        maxContextMsgCount: model.maxContextMsgCount ?? 22,
        temperature: model.temperature,
        maxTokens: model.maxTokens ?? 0,
        updated: getCurrentDateTime(),
        synced: false,
        status: 1);
    currentSessionId = currentSession.sid;
    return currentSession;
  }

  SessionModel getSessionBysid(String sid) {
    // SessionModel? currentSession;
    late SessionTable? st;
    if (sid.isNotEmpty) {
      st = _sessionRepository.findBySessionId(sid);
    } else {
      st = _sessionRepository.findFirst();
    }
    if (st != null) {
      currentSession = SessionModel.fromTable(st);
      currentSessionId = currentSession.sid;
    }
    return currentSession;
  }

  SessionModel switchSession(String sid) {
    return getSessionBysid(sid);
  }

  SessionModel switchSessionModel(String modelName) {
    AiModel aiModel = AppConstants.getAiModel(modelName);
    currentSession.model = aiModel.modelName;
    currentSession.modelType = aiModel.modelType.name;
    currentSession.maxContextMsgCount = aiModel.maxContextMsgCount ?? 22;
    currentSession.maxContextSize = aiModel.maxContextSize;
    return currentSession;
  }

  @Deprecated("message")
  void save() {
    currentSession.updated = getCurrentDateTime();
    _sessionRepository.save(currentSession.toSessionTable());
    getSessionBysid(currentSession.sid);
  }

  void saveSession(SessionModel sessionModel) {
    sessionModel.updated = getCurrentDateTime();
    _sessionRepository.save(sessionModel.toSessionTable());
    // getSessionBysid(sessionModel.sid);
    // sessions.insert(0, sessionModel);
    reloadSessions();
  }

  void updateSessionLastEdit(SessionModel sessionModel) {
    saveSession(sessionModel);
  }

  void remove(SessionModel session) {
    sessions.remove(session);
    _sessionRepository.removeSession(session.sid);
  }
}

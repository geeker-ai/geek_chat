import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/models/settings.dart';
import 'package:geek_chat/models/theme.dart';
import 'package:geek_chat/repository/localstore_repository.dart';
import 'package:geek_chat/service/http_service.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

class ChatGPTRoles {
  final String system = 'system';
  final String assistant = 'assistant';
  final String user = 'user';
}

class SettingsController extends GetxController {
  final settings = SettingsModel();
  final settingsEdit = SettingsModel();
  final chatGPTRoles = ChatGPTRoles();

  // final themeMode = ThemeMode.dark;
  static SettingsController get to => Get.find();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final LocalStoreRepository _localStoreRepository = Get.find();
  // final HttpClientService _httpClientService = Get.find();

  late PackageInfo packageInfo;

  late Directory _dataDir;

  bool debug = kDebugMode;

  DeviceType deviceType = DeviceType.wide;

  final List<AiGroup> _aiGroups = [
    AiGroup(
        aitype: AiType.chatgpt,
        groupName: "ChatGPT",
        groupDesc: "OpenAI ChatGPT"),
    AiGroup(
        aitype: AiType.bard,
        groupName: "Google Vertex AI",
        groupDesc: "Google Vertex AI")
  ];

  List<AiGroup> get aiGroups {
    return _aiGroups;
  }

  List<AiModel> getModelsByType(AiType aiType) {
    List<AiModel> models = [];
    for (AiModel aiModel in _aiModels) {
      if (aiModel.aiType == aiType) {
        models.add(aiModel);
      }
    }
    return models;
  }

  final List<AiModel> _aiModels = [
    AiModel(
        modelName: 'gpt-3.5-turbo',
        alias: 'gpt-3.5',
        aiType: AiType.chatgpt,
        modelType: ModelType.chat,
        temperature: 0.7,
        maxContextSize: 4000,
        modelMaxContextSize: 4000,
        maxTokens: 0),
    AiModel(
        modelName: 'gpt-3.5-turbo-16k',
        alias: 'gpt-3.5-16k',
        aiType: AiType.chatgpt,
        modelType: ModelType.chat,
        temperature: 0.7,
        maxContextSize: 10000,
        modelMaxContextSize: 16000,
        maxTokens: 0),
    AiModel(
        modelName: 'gpt-4',
        alias: 'gpt-4',
        aiType: AiType.chatgpt,
        modelType: ModelType.chat,
        temperature: 0.7,
        maxContextSize: 4000,
        modelMaxContextSize: 4000,
        maxTokens: 0),
    AiModel(
        modelName: 'gpt-4-32k',
        alias: 'gpt-4-32k',
        aiType: AiType.chatgpt,
        modelType: ModelType.chat,
        temperature: 0.7,
        maxContextSize: 15000,
        modelMaxContextSize: 15000,
        maxTokens: 0),
    AiModel(
        modelName: 'chat-bison',
        alias: 'chat-bison',
        aiType: AiType.bard,
        modelType: ModelType.chat,
        temperature: 0.7,
        maxContextSize: 7000,
        modelMaxContextSize: 8192,
        maxTokens: 0),
    AiModel(
        modelName: 'codechat-bison',
        alias: 'codechat-bison',
        aiType: AiType.bard,
        modelType: ModelType.chat,
        temperature: 0.7,
        maxContextSize: 5000,
        modelMaxContextSize: 6144,
        maxTokens: 0),
  ];

  final List<Map<String, String>> serverList = [
    {
      'id': 'openai',
      'name': 'OpenAI',
      'url': 'https://api.openai.com',
    },
    {
      'id': 'geekerchat',
      'name': 'Geeker Chat',
      'url': 'https://capi.fucklina.com',
    },
    {
      'id': 'azure',
      'name': 'Azure API',
      'url': 'https://geek.azure.com',
    }
  ];

  final themeModes = [
    GCThemeMode(name: 'System', themeMode: ThemeMode.system),
    GCThemeMode(name: 'Dark', themeMode: ThemeMode.dark),
    GCThemeMode(name: 'Light', themeMode: ThemeMode.light),
  ];

  Logger logger = Get.find();

  @override
  void onInit() {
    resetSettings();
    super.onInit();
    if (settings.uuid.isEmpty) {
      settings.uuid = const Uuid().v4();
      saveSettings();
    }
  }

  String get channelName {
    String channel = 'dev';
    String envChannel = dotenv.get('CHANNEL');
    if (envChannel.isNotEmpty) {
      channel = envChannel;
    }
    return channel;
  }

  bool get needSettings {
    logger.d("${settings.toJson()}");

    if (settings.provider.trim().isEmpty) {
      logger.d("need settings: true");
      return true;
    }
    return false;
  }

  List<AiModel> get models {
    return _aiModels;
  }

  AiModel getModelByName(String name) {
    AiModel model = _aiModels.first;
    for (AiModel item in _aiModels) {
      if (item.modelName == name) {
        model = item;
        break;
      }
    }
    return model;
  }

  void resetSettings() {
    settings.settingsJson = _localStoreRepository.getSettings().toJson();
    logger.d("init settings: ${settings.toJson()}");
    needReactive = false;
  }

  String get apiHost {
    String apiHost = '';
    if (settings.apiHost.isEmpty) {
      apiHost = getProviderServerDefaultUrl();
      // print(apiHost);
    } else {
      apiHost = settings.apiHost;
    }
    return apiHost;
  }

  String get apiKey {
    String apiKey = '';
    if (settings.apiKey.isNotEmpty) {
      apiKey = settings.apiKey;
    }
    return apiKey;
  }

  String getProviderServer() {
    String server = '';
    for (var item in serverList) {
      if (item['id'] == settings.provider) {
        server = "${item['name']}";
      }
    }
    return server;
  }

  String getProviderServerDefaultUrl() {
    String url = '';
    for (var item in serverList) {
      if (item['id'] == settings.provider) {
        url = "${item['url']}";
      }
    }
    return url;
  }

  ThemeMode getThemeMode() {
    ThemeMode themeMode = ThemeMode.system;
    for (GCThemeMode gcThemeMode in themeModes) {
      if (gcThemeMode.name == settings.theme) {
        themeMode = gcThemeMode.themeMode;
      }
    }
    return themeMode;
  }

  @Deprecated("message")
  void save() {
    settings.settingsJson = settings.toJson();
    _localStoreRepository.saveSettings(settings);
  }

  void saveSettings() {
    settings.settingsJson = settings.toJson();
    logger.d("save settings: ${settings.toJson()}");
    _localStoreRepository.saveSettings(settings);
  }

  set settingsTheme(String theme) {
    settings.theme = theme;
    setThemeMode(getThemeMode());
    saveSettings();
    update();
  }

  setThemeMode(ThemeMode themeMode) {
    Get.changeThemeMode(themeMode);
  }

  String _switcherSelected = '';
  get switcherSelected {
    return _switcherSelected;
  }

  set switcherSelected(value) {
    _switcherSelected = value;
  }

  set dataDir(value) {
    _dataDir = value;
  }

  Directory get dataDir {
    return _dataDir;
  }

  // bool activeLicenseLoading = false;
  bool needReactive = false;
  String activeMessage = '';
  bool activeResult = false;
  String inputLicense = '';
  bool showActiveError = false;

  Future<Map<String, dynamic>> activeLicense(String license) async {
    Map<String, dynamic> rtn = {
      'actived': false,
      'license': license,
      'uuid': settings.uuid,
      'message': '',
      'apiKey': '',
      'baseUrl': ''
    };
    String rtnString = await HttpClientService.activeLicense(
        "https://capi.fucklina.com/activate",
        license,
        settings.uuid,
        settings.language);
    Map<String, dynamic> jsonObj = jsonDecode(rtnString);
    if (jsonObj.containsKey('actived')) {
      rtn['actived'] = jsonObj['actived'];
      rtn['apiKey'] = jsonObj['apiKey'];
      rtn['baseUrl'] = jsonObj['baseUrl'];
      rtn['message'] = jsonObj['message'];
      logger.d("activeLicense: $rtn");
    }
    if (rtn['actived']) {
      settings.isActived = true;
      settings.apiHost = rtn['baseUrl'];
      settings.apiKey = rtn['apiKey'];
      return rtn;
    } else {
      activeMessage = rtn['message'];
      return rtn;
    }
  }
}

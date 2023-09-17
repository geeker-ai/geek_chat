import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/models/settings.dart';
import 'package:geek_chat/models/theme.dart';
import 'package:geek_chat/repository/localstore_repository.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

  late PackageInfo packageInfo;

  late Directory _dataDir;

  var _oriTheme = 'System';
  var _oriLanguage = 'en_US';

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
  ];

  final List<Map<String, String>> locales = [
    {'name': 'Simplified Chinese', 'locale': 'zh_Hans_CN'},
    {'name': 'English', 'locale': 'en_US'}
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
    }
  ];

  final themeModes = [
    GCThemeMode(name: 'System', themeMode: ThemeMode.system),
    GCThemeMode(name: 'Dark', themeMode: ThemeMode.dark),
    GCThemeMode(name: 'Light', themeMode: ThemeMode.light),
  ];

  @override
  void onInit() {
    resetSettings();
    super.onInit();
  }

  List<AiModel> get models {
    return _aiModels;
  }

  AiModel getModelByName(String name) {
    AiModel model = _aiModels.first;
    for (AiModel item in _aiModels) {
      if (item.modelName == name) {
        model = item;
      }
    }
    return model;
  }

  void resetSettings() {
    settings.settingsJson = _localStoreRepository.getSettings().toJson();
    _oriTheme = settings.theme;
    _oriLanguage = settings.language;
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

  String get locale {
    String currentLocale = "${locales[0]['locale']}";
    for (var element in locales) {
      if ("${element['locale']}" == settings.language) {
        currentLocale = "${element['name']}";
      }
    }
    return currentLocale;
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

  void save() {
    settings.settingsJson = settings.toJson();
    _localStoreRepository.saveSettings(settings);
  }

  @Deprecated("message")
  void changeSettings() async {
    if (settings.theme != _oriTheme) {
      setThemeMode(getThemeMode());
    }
    if (settings.language != _oriLanguage) {
      setLocale(settings.language);
    }
  }

  set settingsTheme(String theme) {
    settings.theme = theme;
    setThemeMode(getThemeMode());
    save();
    update();
  }

  set settingsLanguage(String language) {
    settings.language = language;
    setLocale(settings.language);
    update();
    save();
  }

  setThemeMode(ThemeMode themeMode) {
    Get.changeThemeMode(themeMode);
  }

  setLocale(String locale) {
    Get.updateLocale(Locale(locale));
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
}

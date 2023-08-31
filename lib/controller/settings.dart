import 'package:flutter/material.dart';
import 'package:geek_chat/models/settings.dart';
import 'package:geek_chat/models/theme.dart';
import 'package:geek_chat/repository/localstore_repository.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final settings = SettingsModel();
  final settingsEdit = SettingsModel();

  // final themeMode = ThemeMode.dark;
  static SettingsController get to => Get.find();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final LocalStoreRepository _localStoreRepository = Get.find();

  var _oriTheme = 'System';
  var _oriLanguage = 'en_US';

  final locales = [
    {'name': 'Simplified Chinese', 'locale': 'zh_Hans_CN'},
    {'name': 'English', 'locale': 'en_US'}
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

  void resetSettings() {
    settings.settingsJson = _localStoreRepository.getSettings().toJson();
    // print(_localStoreRepository.getSettings().toJson());
    _oriTheme = settings.theme;
    _oriLanguage = settings.language;
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

  ThemeMode getThemeMode() {
    ThemeMode themeMode = ThemeMode.system;
    for (GCThemeMode gcThemeMode in themeModes) {
      if (gcThemeMode.name == settings.theme) {
        themeMode = gcThemeMode.themeMode;
      }
    }
    // print(themeMode);
    return themeMode;
  }

  void save() {
    settings.settingsJson = settings.toJson();
    _localStoreRepository.saveSettings(settings);
    changeSettings();
  }

  void changeSettings() async {
    if (settings.theme != _oriTheme) {
      setThemeMode(getThemeMode());
    }
    if (settings.language != _oriLanguage) {
      setLocale(settings.language);
    }
  }

  void setThemeMode(ThemeMode themeMode) async {
    Get.changeThemeMode(themeMode);
  }

  void setLocale(String locale) async {
    Get.updateLocale(Locale(locale));
  }
}

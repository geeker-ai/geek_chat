import 'package:flutter/material.dart';
import 'package:geek_chat/models/settings.dart';
import 'package:geek_chat/repository/localstore_repository.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final settings = SettingsModel();
  final settingsEdit = SettingsModel();

  // final themeMode = ThemeMode.dark;
  static SettingsController get to => Get.find();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final LocalStoreRepository _localStoreRepository = Get.find();

  var _oriTheme = ThemeMode.system;
  var _oriLanguage = 'en_US';

  final locales = [
    {'name': 'Chinese', 'locale': 'en_US'},
    {'name': 'English', 'locale': 'zh_Hans_CN'}
  ];
  final themeModels = [
    {'name': 'System', 'mode': ThemeMode.system},
    {'name': 'Dark', 'mode': ThemeMode.dark},
    {'name': 'Light', 'mode': ThemeMode.light}
  ];

  @override
  void onInit() {
    super.onInit();
    resetSettings();
  }

  void resetSettings() {
    settings.settingsJson = _localStoreRepository.getSettings().toJson();
    _oriTheme = settings.theme;
    _oriLanguage = settings.language;
  }

  void save() {
    settings.settingsJson = settingsEdit.toJson();
    _localStoreRepository.saveSettings(settings);
  }

  void changeSettings() async {
    if (settings.theme != _oriTheme) {
      setThemeMode(settings.theme);
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

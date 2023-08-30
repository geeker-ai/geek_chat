import 'dart:convert';

import 'package:geek_chat/models/settings.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalStoreRepository extends GetxService {
  final GetStorage store = GetStorage("geekchat");

  final String _settingsKey = 'settings';

  SettingsModel getSettings() {
    String jsonstr = '';
    SettingsModel settings = SettingsModel();
    if (store.hasData(_settingsKey)) {
      jsonstr = store.read(_settingsKey);
      settings.settingsJson = jsonDecode(jsonstr);
    } else {
      settings.language = Get.deviceLocale.toString();
    }

    return settings;
  }

  saveSettings(SettingsModel settings) {
    String jsonStr = jsonEncode(settings);
    store.write(_settingsKey, jsonStr);
  }
}

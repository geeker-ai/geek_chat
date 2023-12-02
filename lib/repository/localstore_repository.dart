import 'dart:convert';

import 'package:geek_chat/models/server.dart';
import 'package:geek_chat/models/settings.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalStoreRepository extends GetxService {
  LocalStoreRepository({required storageName}) {
    store = GetStorage(storageName);
  }
  late GetStorage store;

  final String _settingsKey = 'settings';
  final String _prompsKey = 'prompts';
  final String _promptsLastUpdateKey = 'prompts_last';

  final String _serverProviderPrefix = '_server_settings_';

  ServerModel getServerSettings(provider) {
    ServerModel serverModel;
    String key = "${_serverProviderPrefix}_$provider";
    if (store.hasData(key)) {
      serverModel = ServerModel.fromJson(store.read(key));
    } else {
      serverModel = ServerModel(provider: provider);
    }
    return serverModel;
  }

  saveSeverSettings(ServerModel serverModel) {
    String key = "${_serverProviderPrefix}_${serverModel.provider}";
    store.write(key, serverModel.toJson());
  }

  String getPromptsJsonString() {
    String jsonStr = '';
    if (store.hasData(_prompsKey)) {
      jsonStr = store.read(_prompsKey);
    }
    return jsonStr;
  }

  savePrompts(String jsonStr) {
    store.write(_prompsKey, jsonStr);
  }

  String getPromptsLastUpdate() {
    String lastUpdate = '';
    if (store.hasData(_promptsLastUpdateKey)) {
      lastUpdate = store.read(_promptsLastUpdateKey);
    }
    return lastUpdate;
  }

  updatePromptsLastUpdate(String updated) {
    store.write(_promptsLastUpdateKey, updated);
  }

  SettingsModel getSettings() {
    String jsonstr = '';
    SettingsModel settings = SettingsModel();
    if (store.hasData(_settingsKey)) {
      jsonstr = store.read(_settingsKey);
      settings.settingsJson = jsonDecode(jsonstr);
    } else {
      // settings.language = Get.deviceLocale.toString();
    }

    return settings;
  }

  saveSettings(SettingsModel settings) {
    String jsonStr = jsonEncode(settings);
    store.write(_settingsKey, jsonStr);
  }

  T? read<T>(String key) {
    return store.read(key);
  }

  Future<void> write(String key, dynamic value) async {
    await store.write(key, value);
  }
}

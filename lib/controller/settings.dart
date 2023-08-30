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

  @override
  void onInit() {
    super.onInit();
    settings.settingsJson = _localStoreRepository.getSettings().toJson();
    settingsEdit.settingsJson = settings.toJson();
  }

  void save() {
    settings.settingsJson = settingsEdit.toJson();
    _localStoreRepository.saveSettings(settings);
  }
}

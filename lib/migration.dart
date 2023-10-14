import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/controller/settings_server_controller.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class GeekChatMigration {
  SettingsController settingsController = Get.find();
  SettingsServerController settingsServerController = Get.find();

  Logger logger = Get.find();

  void migrate() {
    migrateOldServerConfig();
  }

  void migrateOldServerConfig() {
    logger.d("enter migrate old server config");
    if (settingsServerController.defaultServer.apiKey.isEmpty &&
        settingsController.apiKey.isNotEmpty) {
      logger.d("start migrate old server config");
      settingsServerController.defaultServer.apiHost =
          settingsController.settings.apiHost;
      settingsServerController.defaultServer.apiKey =
          settingsController.settings.apiKey;
      settingsServerController.defaultServer.isActived =
          settingsController.settings.isActived;
      settingsServerController.defaultServer.license =
          settingsController.settings.license;
      settingsServerController
          .saveSettings(settingsServerController.defaultServer);
      settingsController.settings.apiHost = '';
      settingsController.settings.apiKey = '';
      settingsController.settings.isActived = false;
      settingsController.settings.license = '';
    }
  }
}

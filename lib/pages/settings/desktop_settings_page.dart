import 'package:flutter/material.dart';
import 'package:geek_chat/components/main_settings_component.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/controller/tracker_controller.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class DesktopSettingsPage extends StatelessWidget {
  DesktopSettingsPage({super.key});

  SettingsController settingsController = Get.find();
  TrackerController trackerController = Get.find();

  @override
  Widget build(BuildContext context) {
    trackerController.trackEvent(
        "Page-Settings", {"uuid": settingsController.settings.uuid});
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'.tr),
      ),
      body: SettingsComponent(),
    );
  }
}

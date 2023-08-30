import 'package:flutter/material.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'.tr),
        ),
        body: GetBuilder<SettingsController>(
          builder: (controller) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                const Divider(),
                ListTile(
                  dense: true,
                  title: Text(
                    'theme'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                RadioListTile(
                    title: Text('System'.tr),
                    value: ThemeMode.system,
                    groupValue: controller.settingsEdit.theme,
                    onChanged: (value) {
                      controller.settingsEdit.theme = ThemeMode.system;
                      controller.update();
                    }),
                RadioListTile(
                    title: Text('Dark'.tr),
                    value: ThemeMode.dark,
                    groupValue: controller.settingsEdit.theme,
                    onChanged: (value) {
                      controller.settingsEdit.theme = ThemeMode.dark;
                      controller.update();
                    }),
                RadioListTile(
                    title: Text('Light'.tr),
                    value: ThemeMode.light,
                    groupValue: controller.settingsEdit.theme,
                    onChanged: (value) {
                      controller.settingsEdit.theme = ThemeMode.light;
                      controller.update();
                    }),
                const Divider(),
                ListTile(
                  dense: true,
                  title: Text('Language'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                RadioListTile(
                    title: const Text('Simplified Chinese'),
                    value: 'zh_Hans_CN',
                    groupValue: controller.settingsEdit.language,
                    onChanged: (value) {
                      controller.settingsEdit.language = 'zh_Hans_CN';
                      controller.update();
                    }),
                RadioListTile(
                    title: const Text('US English'),
                    value: 'en_US',
                    groupValue: controller.settingsEdit.language,
                    onChanged: (value) {
                      controller.settingsEdit.language = 'en_US';
                      controller.update();
                    })
              ],
            );
          },
        ));
  }
}

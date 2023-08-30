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
                    groupValue: controller.settings.theme,
                    onChanged: (value) {
                      controller.settings.theme = ThemeMode.system;
                      // controller.changeSettings();
                      controller.update();
                    }),
                RadioListTile(
                    title: Text('Dark'.tr),
                    value: ThemeMode.dark,
                    groupValue: controller.settings.theme,
                    onChanged: (value) {
                      controller.settings.theme = ThemeMode.dark;
                      // controller.changeSettings();
                      controller.update();
                    }),
                RadioListTile(
                    title: Text('Light'.tr),
                    value: ThemeMode.light,
                    groupValue: controller.settings.theme,
                    onChanged: (value) {
                      controller.settings.theme = ThemeMode.light;
                      // controller.changeSettings();
                      controller.update();
                    }),
                const Divider(),
                ListTile(
                  dense: true,
                  title: Text('Language'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                for (var element in controller.locales)
                  RadioListTile(
                      title: Text("${element['name']}"),
                      value: element['locale'],
                      groupValue: controller.settings.language,
                      onChanged: (value) {
                        controller.settings.language = "${element['locale']}";
                        // controller.changeSettings();
                        controller.update();
                      })

                // RadioListTile(
                //     title: const Text('US English'),
                //     value: 'en_US',
                //     groupValue: controller.settings.language,
                //     onChanged: (value) {
                //       controller.settings.language = 'en_US';
                //       controller.changeSettings();
                //       controller.update();
                //     })
              ],
            );
          },
        ));
  }
}

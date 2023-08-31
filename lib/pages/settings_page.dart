import 'package:flutter/material.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/theme.dart';
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
                for (GCThemeMode themeMode in controller.themeModes)
                  RadioListTile(
                      title: Text(themeMode.name.tr),
                      value: themeMode.themeMode,
                      groupValue: controller.settings.theme,
                      onChanged: (value) {
                        controller.settings.theme = themeMode.themeMode;
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
                      }),
                const Divider(),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(child: const Text("Save"), onPressed: () {}),
                    const SizedBox(width: 30.0),
                    OutlinedButton(
                        child: const Text("Cancel"), onPressed: () {}),
                  ],
                ),
              ],
            );
          },
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:geek_chat/components/settings/language_switch.dart';
import 'package:geek_chat/components/settings/theme_switch.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:get/get.dart';

class SettingsComponent extends StatelessWidget {
  const SettingsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: ((controller) {
      return ListView(
        // padding: EdgeInsets.zero,
        padding: const EdgeInsets.only(
            left: 10.0, top: 0.0, right: 20.0, bottom: 0.0),
        children: [
          const Divider(),
          ListTile(
            dense: true,
            title: Text(
              'OpenAI Settings'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("OpenAI Settings".tr),
                const Text(
                  "API Key, API Server ",
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            leading: const Icon(Icons.color_lens_outlined),
            trailing: const Icon(Icons.chevron_right_outlined),
            onTap: () {
              // SmartSelect.single(selectedValue: selectedValue)
            },
          ),
          const Divider(),
          ListTile(
            dense: true,
            title: Text(
              'theme'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ThemeSwitchComponent(
            tile: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("theme".tr),
                  Text(
                    controller.settings.theme.tr,
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              ),
              leading: const Icon(Icons.color_lens_outlined),
              // trailing: const Icon(Icons.chevron_right_outlined),
            ),
          ),
          const Divider(),
          ListTile(
            dense: true,
            title: Text(
              'Language Settings'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          LanguageSwitchComponent(
              tile: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Language Settings".tr),
                Text(
                  controller.locale.tr,
                  style: const TextStyle(fontSize: 12),
                )
              ],
            ),
            leading: const Icon(Icons.language_outlined),
            // trailing: const Icon(Icons.chevron_right_outlined),
            // onTap: () {
            //   // showLangauageSelector();
            // },
          )),
        ],
      );
    }));
  }
}

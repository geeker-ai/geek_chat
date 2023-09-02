import 'package:flutter/material.dart';
import 'package:geek_chat/components/settings/bottom_sheet_switcher.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/theme.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class SettingsComponent extends StatelessWidget {
  const SettingsComponent({super.key});

  // late List<Map<String, String>> options;

  List<Map<String, String>> getLanguageOptions() {
    List<Map<String, String>> options = [];
    for (Map<String, String> item in SettingsController.to.locales) {
      options.add({'name': item['locale'] ?? '', 'title': item['name'] ?? ''});
    }
    return options;
  }

  List<Map<String, String>> getThemeOptions() {
    List<Map<String, String>> themeOptions = [];
    for (GCThemeMode theme in SettingsController.to.themeModes) {
      themeOptions.add({'name': theme.name, 'title': theme.name});
    }
    return themeOptions;
  }

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
              Get.toNamed('/settings');
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
          BottomSheetSwitcherComponent(
            title: "Theme Settings",
            subTitle: controller.settings.theme,
            selectedValue: controller.settings.theme,
            options: getThemeOptions(),
            leadingIcon: Icons.color_lens_outlined,
            onTapCallback: (value) {
              controller.settingsTheme = value;
              controller.save();
            },
          ),
          const Divider(),
          ListTile(
            dense: true,
            title: Text(
              'Language Settings'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          BottomSheetSwitcherComponent(
            title: "Language Settings",
            subTitle: controller.locale,
            selectedValue: controller.settings.language,
            options: getLanguageOptions(),
            leadingIcon: Icons.language_outlined,
            onTapCallback: (value) {
              controller.settingsLanguage = value;
              controller.save();
            },
          ),
        ],
      );
    }));
  }
}

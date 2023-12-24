import 'package:flutter/material.dart';
import 'package:geek_chat/components/settings/azure_server_component.dart';
import 'package:geek_chat/components/settings/bottom_sheet_switcher.dart';
import 'package:geek_chat/components/settings/geekerchat_active.dart';
import 'package:geek_chat/components/settings/google_gemini_server_component.dart';
import 'package:geek_chat/components/settings/standard_server.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/controller/settings_server_controller.dart';
import 'package:geek_chat/models/server.dart';
import 'package:geek_chat/util/app_constants.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ServerSettingsPage extends StatelessWidget {
  ServerSettingsPage({super.key});

  // List<Map<String, String>> options = [
  //   {'name': 'openai', 'title': 'OpenAI'},
  //   {'name': 'geekerchat', 'title': 'GeekerChat'}
  // ];

  SettingsController settingsController = Get.find();
  SettingsServerController settingsServerController = Get.find();

  List<Map<String, String>> getOptions() {
    List<Map<String, String>> options = [];
    for (ProviderModel item in AppConstants.servers) {
      options.add({'name': item.id, 'title': item.name});
    }
    return options;
  }

  String getServerTitle(String name) {
    String title = 'Please Select a server';
    for (Map<String, String> option in getOptions()) {
      if (option['name'] == name) {
        title = option['title']!;
      }
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    settingsServerController
        .switchSettings(settingsController.settings.provider);
    return Scaffold(
      appBar: AppBar(
        title: Text('OpenAI Settings'.tr),
      ),
      body: GetBuilder<SettingsServerController>(builder: ((controller) {
        return ListView(
          padding: const EdgeInsets.only(
              left: 10.0, top: 0.0, right: 20.0, bottom: 0.0),
          children: [
            const Divider(),
            ListTile(
              dense: true,
              title: Text(
                'API Server'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            BottomSheetSwitcherComponent(
              title: "Server Settings",
              subTitle: getServerTitle(controller.defaultServer.provider),
              selectedValue: controller.defaultServer.provider,
              options: getOptions(),
              leadingIcon: Icons.computer_outlined,
              onTapCallback: (value) {
                // controller.provider = value;
                controller.switchSettings(value);
                controller.update();
                // controller.saveSettings();
              },
            ),
            switchServerSettingsComponent(controller.defaultServer.provider)
          ],
        );
      })),
    );
  }

  Widget switchServerSettingsComponent(String provider) {
    if (provider == 'geekerchat') {
      return GeekerChatSettingsComponent();
    } else if (provider == 'openai') {
      return StandardServerSettingsComponent();
    } else if (provider == 'azure') {
      return AzureServerSettingsComponent();
    } else if (provider == 'gemini') {
      return GooleGeminiServerSettingsComponent();
    }
    return const SizedBox();
  }
}

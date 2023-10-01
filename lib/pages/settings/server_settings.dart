import 'package:flutter/material.dart';
import 'package:geek_chat/components/settings/bottom_sheet_switcher.dart';
import 'package:geek_chat/components/settings/geekerchat_active.dart';
import 'package:geek_chat/components/settings/standard_server.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ServerSettingsPage extends StatelessWidget {
  ServerSettingsPage({super.key});

  List<Map<String, String>> options = [
    {'name': 'openai', 'title': 'OpenAI'},
    {'name': 'geekerchat', 'title': 'GeekerChat'}
  ];

  String getServerTitle(String name) {
    String title = '';
    for (Map<String, String> option in options) {
      if (option['name'] == name) {
        title = option['title']!;
      }
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OpenAI Settings'.tr),
      ),
      body: GetBuilder<SettingsController>(builder: ((controller) {
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
              title: "OpenAI Settings",
              subTitle: getServerTitle(controller.settings.provider),
              selectedValue: controller.settings.provider,
              options: options,
              leadingIcon: Icons.computer_outlined,
              onTapCallback: (value) {
                controller.settings.provider = value;
                controller.update();
                controller.save();
              },
            ),
            switchServerSettingsComponent(controller.settings.provider)
          ],
        );
      })),
    );
  }
}

Widget switchServerSettingsComponent(String provider) {
  if (provider == 'geekerchat') {
    return GeekerChatSettingsComponent();
  } else if (provider == 'openai') {
    return const StandardServerSettingsComponent();
  }
  return const SizedBox();
}

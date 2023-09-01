import 'package:flutter/material.dart';
import 'package:geek_chat/components/settings/api_server_switcher.dart';
import 'package:geek_chat/components/settings/geekerchat_active.dart';
import 'package:geek_chat/components/settings/standard_server.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:get/get.dart';

class ServerSettingsPage extends StatelessWidget {
  const ServerSettingsPage({super.key});

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
            ApiServerSwitchComponent(),
            switchServerSettingsComponent(controller.settings.provider)
          ],
        );
      })),
    );
  }
}

Widget switchServerSettingsComponent(String provider) {
  if (provider == 'geekerchat') {
    return const GeekerChatSettingsComponent();
  } else if (provider == 'openai') {
    return const StandardServerSettingsComponent();
  }
  return const SizedBox();
}

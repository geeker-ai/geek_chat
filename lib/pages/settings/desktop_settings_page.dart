import 'package:flutter/material.dart';
import 'package:geek_chat/components/main_settings_component.dart';
import 'package:get/get.dart';

class DesktopSettingsPage extends StatelessWidget {
  const DesktopSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'.tr),
      ),
      body: SettingsComponent(),
    );
  }
}

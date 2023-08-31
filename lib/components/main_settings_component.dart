import 'package:flutter/material.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:get/get.dart';

class SettingsComponent extends StatelessWidget {
  const SettingsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: ((controller) {
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
        ],
      );
    }));
  }
}

import 'package:flutter/material.dart';
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
              'theme'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("theme".tr),
                const Text(
                  "跟随系统",
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            leading: const Icon(Icons.color_lens_outlined),
            trailing: const Icon(Icons.chevron_right_outlined),
          ),
          const Divider(),
          ListTile(
            dense: true,
            title: Text(
              'OpenAI Settings'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("OpenAI 设置"),
                Text(
                  "API Key, API Server ",
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            leading: Icon(Icons.color_lens_outlined),
            trailing: Icon(Icons.chevron_right_outlined),
          ),
          const Divider(),
          ListTile(
            dense: true,
            title: Text(
              'langauage'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("语言设置"),
                Text(
                  "简体中文",
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            leading: Icon(Icons.language_outlined),
            trailing: Icon(Icons.chevron_right_outlined),
          ),
        ],
      );
    }));
  }
}

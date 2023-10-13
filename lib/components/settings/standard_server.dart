import 'package:flutter/material.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/controller/settings_server_controller.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class StandardServerSettingsComponent extends StatelessWidget {
  StandardServerSettingsComponent({super.key});

  SettingsController settingsController = Get.find();
  SettingsServerController settingsServerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsServerController>(builder: (controller) {
      return Wrap(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          ListTile(
            title: Text("Server Configuration".tr),
          ),
          // Padding(padding: paddingOnly())
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 10),
            child: TextFormField(
              initialValue: controller.defaultServer.apiHost,
              decoration: const InputDecoration(
                labelText: 'API Host',
                filled: false,
                // errorText: 'Error!',
                // border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                controller.defaultServer.apiHost = value.trim();
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 20, bottom: 0, right: 10),
            child: TextFormField(
              initialValue: controller.defaultServer.apiKey,
              decoration: const InputDecoration(
                labelText: 'API Key',
                filled: false,
              ),
              onChanged: (value) {
                controller.defaultServer.apiKey = value.trim();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    controller.defaultServer.isActived = false;
                    // settingsController.needReactive = true;
                    // controller.defaultServer.
                    // controller.saveSettings();
                    controller.saveSettings(controller.defaultServer);
                    settingsController.settings.provider =
                        controller.defaultServer.provider;
                    settingsController.saveSettings();
                    Get.snackbar(
                      "Saved successfully!".tr,
                      "The configuration has been updated!".tr,
                      icon: const Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      snackPosition: SnackPosition.TOP,
                    );
                  },
                  child: Text('Save'.tr),
                ),
                const SizedBox(
                  width: 30,
                ),
                OutlinedButton(
                  onPressed: () {
                    // controller.resetSettings();
                    Get.back();
                  },
                  child: Text('Cancel'.tr),
                )
              ],
            ),
          )
        ],
      );
    });
  }
}

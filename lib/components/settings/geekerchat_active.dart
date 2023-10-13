import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/controller/settings_server_controller.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class GeekerChatSettingsComponent extends StatelessWidget {
  GeekerChatSettingsComponent({super.key});

  SettingsController settingsController = Get.find();
  Logger logger = Get.find();

  TextEditingController textEditingController = TextEditingController();
  SettingsServerController settingsServerController = Get.find();

  Icon getTextInputIcon(bool isActive, bool needReactive) {
    if (isActive && !needReactive) {
      return const Icon(
        Icons.check,
        color: Colors.green,
      );
    }
    return const Icon(
      Icons.check,
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsServerController>(builder: (controller) {
      textEditingController.text = controller.defaultServer.license;
      logger.d("init: ${controller.defaultServer.toJson()}");
      return Wrap(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          ListTile(
            dense: true,
            title: Text(
              "GeekerChat Configuration".tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 0, bottom: 20, right: 10),
            child: Column(
              children: [
                TextField(
                  // initialValue: controller.settings.license,
                  controller: textEditingController,
                  decoration: InputDecoration(
                    labelText: 'License',
                    filled: false,
                    suffixIcon: getTextInputIcon(
                        controller.defaultServer.isActived,
                        controller.needReactive),
                  ),
                  onChanged: (value) {
                    controller.defaultServer.license = value.trim();
                    controller.needReactive = true;
                    controller.update();
                  },
                ),
                if (settingsController.showActiveError)
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning,
                          color: Colors.yellow[700],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(settingsController.activeMessage)
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: () {
                    if (controller.defaultServer.license.isNotEmpty) {
                      controller
                          .activeLicense(
                              controller.defaultServer.license,
                              settingsController.settings.uuid,
                              settingsController.lang)
                          .then((value) {
                        if (value.isActived) {
                          logger.d("actie: ${value.toJson()}");
                          // controller.defaultServer = value;
                          controller.saveSettings(value);
                          settingsController.settings.provider = value.provider;
                          settingsController.saveSettings();
                        } else {
                          //
                        }
                      });
                      // settingsController
                      //     .activeLicense(controller.defaultServer.license)
                      //     .then((value) {
                      //   logger.d("value: $value");
                      //   if (value['actived']) {
                      //     showCustomToast(
                      //         title: "Active Success".tr, context: context);
                      //     settingsController.needReactive = false;
                      //     // controller.saveSettings();
                      //     Get.back();
                      //   } else {
                      //     // settingsController.activeMessage = value['message'];
                      //     // settingsController.showActiveError = true;
                      //     logger.d(
                      //         "message1: ${settingsController.activeMessage}");
                      //     controller.update();
                      //     logger.d(
                      //         "message2: ${settingsController.activeMessage}");
                      //   }
                      // });
                    } else {
                      showCustomToast(
                          title: "Please Activate First".tr, context: context);
                    }
                    // }
                  },
                  child: Text("Save".tr)),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () {
                  // controller.resetSettings();
                  // settingsController.showActiveError = false;
                  Get.back();
                },
                child: Text("Cancel".tr),
              ),
            ],
          ),
          if (settingsController.channelName == 'site')
            Card(
              margin: const EdgeInsets.only(top: 15),
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("buytips".tr),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          launchUrl(
                              Uri.parse("https://geeker.lemonsqueezy.com/"));
                        },
                        child: Text("Buy".tr),
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class GeekerChatSettingsComponent extends StatelessWidget {
  GeekerChatSettingsComponent({super.key});

  SettingsController settingsController = Get.find();
  Logger logger = Get.find();

  TextEditingController textEditingController = TextEditingController();

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
    return GetBuilder<SettingsController>(builder: (controller) {
      textEditingController.text = controller.settings.license;
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
                        controller.settings.isActived, controller.needReactive),
                  ),
                  onChanged: (value) {
                    controller.settings.license = value.trim();
                    controller.needReactive = true;
                    controller.update();
                  },
                ),
                if (controller.showActiveError)
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
                        Text(controller.activeMessage)
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
                    if (controller.settings.license.isNotEmpty) {
                      controller
                          .activeLicense(controller.settings.license)
                          .then((value) {
                        logger.d("value: $value");
                        if (value['actived']) {
                          showCustomToast(
                              title: "Active Success".tr, context: context);
                          controller.needReactive = false;
                          controller.saveSettings();
                          Get.back();
                        } else {
                          controller.activeMessage = value['message'];
                          controller.showActiveError = true;
                          logger.d("message1: ${controller.activeMessage}");
                          controller.update();
                          logger.d("message2: ${controller.activeMessage}");
                        }
                      });
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
                    controller.resetSettings();
                    controller.showActiveError = false;
                    Get.back();
                  },
                  child: Text("Cancel".tr)),
            ],
          ),
        ],
      );
    });
  }
}

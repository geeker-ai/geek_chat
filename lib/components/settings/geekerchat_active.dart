import 'package:flutter/material.dart';
import 'package:geek_chat/controller/locale_controller.dart';
import 'package:geek_chat/controller/main_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/controller/settings_server_controller.dart';
import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class GeekerChatSettingsComponent extends StatelessWidget {
  GeekerChatSettingsComponent({super.key});

  SettingsController settingsController = Get.find();
  LocaleController localeController = Get.find();
  Logger logger = Get.find();

  TextEditingController textEditingController = TextEditingController();
  SettingsServerController settingsServerController = Get.find();
  MainController mainController = Get.find();

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
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
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
                  autofocus: true,
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
                if (controller.activeError)
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
                        Text(controller.errorMessage)
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
                    submitActive(controller, context);
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
            Column(
              children: getPaymentInfo(controller, context),
            ),
        ],
      );
    });
  }

  submitActive(SettingsServerController controller, BuildContext context) {
    logger.d(
        "default server provider: ${settingsServerController.defaultServer.provider}");
    logger.d("settings server provider: ${settingsServerController.provider}");
    if (controller.defaultServer.license.isNotEmpty) {
      if (controller.needReactive) {
        controller
            .activeLicense(controller.defaultServer.license,
                settingsController.settings.uuid, localeController.locale.lang)
            .then((value) {
          if (value.isActived) {
            logger.d("actie: ${value.toJson()}");
            // controller.defaultServer = value;
            controller.saveSettings(value);
            controller.needReactive = false;
            settingsController.settings.provider = value.provider;
            settingsController.saveSettings();
            showCustomToast(title: "Active Success".tr, context: context);
            controller.activeError = false;
            controller.errorMessage = '';
            controller.update();
          } else {
            logger.d("active: $value");
            showCustomToast(title: "Active Faild!".tr, context: context);
            // controller.defaultServer.message = value.message;
            // controller.defaultServer.error = true;
            controller.activeError = true;
            controller.errorMessage = value.message;
            controller.update();
          }
        });
      } else {
        if (settingsServerController.defaultServer.isActived) {
          // settingsController.settings.provider = value.provider;
          settingsController.settings.provider =
              settingsServerController.provider;
          settingsController.saveSettings();
          showCustomToast(title: "Save successful".tr, context: context);
        }
      }
    } else {
      showCustomToast(title: "Save successful".tr, context: context);
    }
    // mainController.update();
    // settingsController.update(['subscription']);
  }

  List<Widget> getPaymentInfo(
      SettingsServerController controller, BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(Card(
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
      elevation: 5,
      child: Container(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("buytips".tr),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Supported Models: ".tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5, left: 5),
              child: const Text("• OpenAI"),
            ),
            for (AiModel model in settingsController.models)
              if (model.aiType == AiType.chatgpt)
                Container(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: Text("⁃ ${model.modelName}"),
                ),
            Container(
              padding: const EdgeInsets.only(top: 5, left: 5),
              child: const Text("• Google Vertex AI"),
            ),
            for (AiModel model in settingsController.models)
              if (model.aiType == AiType.bard)
                Container(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: Text("⁃ ${model.modelName}"),
                ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Model Price: ".tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, top: 0),
              child: Row(
                children: [
                  const Text("OpenAi: "),
                  TextButton(
                      onPressed: () {
                        launchUrl(Uri.parse("https://openai.com/pricing"));
                      },
                      child: const Text(
                        "https://openai.com/pricing",
                        overflow: TextOverflow.ellipsis,
                      ))
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, top: 0),
              child: Row(
                children: [
                  const Text("Google:"),
                  TextButton(
                      onPressed: () {
                        launchUrl(Uri.parse(
                            "https://cloud.google.com/vertex-ai/pricing?hl=en"));
                      },
                      child: const Text(
                        "https://cloud.google.com/.../pricing",
                        overflow: TextOverflow.ellipsis,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    ));
    return widgets;
  }
}

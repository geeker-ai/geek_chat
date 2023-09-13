import 'package:flutter/material.dart';
import 'package:geek_chat/components/settings/bottom_sheet_switcher.dart';
import 'package:geek_chat/controller/chat_list_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/model.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ChatEditPage extends StatelessWidget {
  ChatEditPage({super.key});

  SettingsController settingsController = Get.find<SettingsController>();

  List<Map<String, String>> getModelOptions() {
    List<Map<String, String>> options = [];
    for (AiModel item in settingsController.models) {
      options.add({'name': item.modelName, 'title': item.modelName});
    }
    return options;
  }

  String getTitle(String? opt) {
    String title = "New Chat";
    if (opt == 'edit') {
      title = 'Edit Chat';
    }
    return title;
  }

  ChatListController chatListController = Get.find<ChatListController>();

  @override
  Widget build(BuildContext context) {
    var data = Get.parameters;
    var options = getModelOptions();
    if (data['opt'] == 'new') {
      chatListController.createNewSession();
    } else {
      chatListController.getSessionBysid(data['sid']!);
    }
    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<ChatListController>(builder: (controller) {
          return Text(getTitle(data['opt']).tr);
        }),
      ),
      body: GetBuilder<ChatListController>(builder: (controller) {
        return ListView(
          padding: const EdgeInsets.only(
              left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
          children: [
            const Divider(),
            ListTile(
              dense: true,
              title: Text(
                'Session Name'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, bottom: 10, right: 10),
              child: TextFormField(
                initialValue: controller.currentSession.name,
                decoration: InputDecoration(
                  labelText: 'Session Name'.tr,
                  filled: false,
                ),
                onChanged: (value) {
                  // controller.settings.apiKey = value;
                  controller.currentSession.name = value;
                  controller.update();
                },
              ),
            ),
            ListTile(
              dense: true,
              title: Text(
                'Prompt'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, bottom: 10, right: 10),
              child: TextFormField(
                initialValue: controller.currentSession.promptContent,
                decoration: const InputDecoration(
                  // labelText: 'Prompt'.tr,
                  filled: false,
                ),
                minLines: 4,
                maxLines: 4,
                onChanged: (value) {
                  controller.currentSession.promptContent = value;
                  controller.update();
                },
              ),
            ),
            ListTile(
              dense: true,
              title: Text(
                'temperature'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SliderTheme(
              // padding: const EdgeInsets.only(
              //     left: 10, top: 0, bottom: 10, right: 10),
              data: const SliderThemeData(
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: Slider(
                value: controller.currentSession.temperature,
                max: 1,
                min: 0,
                divisions: 10,
                onChanged: (value) {
                  controller.currentSession.temperature = value;
                  controller.update();
                },
                label: controller.currentSession.temperature.toString(),
              ),
            ),
            ListTile(
              dense: true,
              title: Text(
                'History Message'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SliderTheme(
              data: const SliderThemeData(
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: Slider(
                onChanged: (value) {
                  // print(value);
                  int count = value.floor();
                  controller.currentSession.maxContextMsgCount = count;
                  controller.update();
                },
                value: controller.currentSession.maxContextMsgCount.toDouble(),
                min: 0,
                max: 22,
                divisions: 22,
                label: controller.currentSession.maxContextMsgCount.toString(),
              ),
            ),
            ListTile(
              dense: true,
              title: Text(
                'Model'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            BottomSheetSwitcherComponent(
                title: 'Model',
                subTitle: controller.currentSession.model,
                selectedValue: controller.currentSession.model,
                options: options,
                leadingIcon: Icons.smart_toy_outlined,
                onTapCallback: (value) {
                  controller.currentSession.model = value;
                  controller.update();
                }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      controller.save();
                      chatListController.reloadSessions();
                      chatListController.update();
                      Get.back();
                      Get.snackbar(
                        "Saved successfully!".tr,
                        "New chat created successful!".tr,
                        icon: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 2),
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
      }),
    );
  }
}

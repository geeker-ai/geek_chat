import 'package:flutter/material.dart';
// import 'package:geek_chat/components/settings/bottom_sheet_switcher.dart';
import 'package:geek_chat/components/settings/grouped_bottom_sheet_switcher.dart';
import 'package:geek_chat/controller/chat_list_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/controller/settings_server_controller.dart';
import 'package:geek_chat/controller/tracker_controller.dart';
import 'package:geek_chat/models/bottom_switcher_model.dart';
import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/models/server.dart';
import 'package:geek_chat/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class ChatEditPage extends StatelessWidget {
  ChatEditPage({super.key});

  SettingsController settingsController = Get.find<SettingsController>();
  SettingsServerController settingsServerController = Get.find();
  TrackerController tracker = Get.find();
  Logger logger = Get.find();

  List<Map<String, String>> getModelOptions() {
    List<Map<String, String>> options = [];
    for (AiModel item in settingsController.models) {
      options.add({
        'name': item.modelName,
        'title': item.modelName,
      });
    }
    return options;
  }

  List<GroupedBottomSwitcherOption> getGroupedModelOptions() {
    List<GroupedBottomSwitcherOption> options = [];
    ProviderModel providerModel = AppConstants.getProvider(
        settingsServerController.defaultServer.provider);
    for (AiGroup group in settingsController.aiGroups) {
      // options.add(value)
      GroupedBottomSwitcherOption gOptions = GroupedBottomSwitcherOption(
          groupName: group.groupName, groupDesc: group.groupDesc);

      for (AiModel model in settingsController.getModelsByType(group.aitype)) {
        bool disabled = false;
        //// is supported model
        // if (settingsServerController.defaultServer.provider != "geekerchat" &&
        //     model.aiType == AiType.bard) {
        if (!providerModel.supportedModels.contains(model.modelName)) {
          disabled = true;
        } else if (isEdit) {
          if (chatListController.currentSession.modelType !=
              model.modelType.name) {
            disabled = true;
          }
        }
        gOptions.options.add(BottomSwitcherOption(
            id: model.modelName,
            name: model.modelName.toUpperCase(),
            additionalText: "",
            disabled: disabled));
      }
      options.add(gOptions);
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

  bool isEdit = false;

  ChatListController chatListController = Get.find<ChatListController>();

  @override
  Widget build(BuildContext context) {
    var data = Get.parameters;
    // var options = getModelOptions();

    if (data['opt'] == 'new') {
      chatListController.createNewSession();
      tracker.trackEvent(
          "Page-newchat", {"uuid": settingsController.settings.uuid});
    } else {
      isEdit = true;
      chatListController.getSessionBysid(data['sid']!);
      tracker.trackEvent(
          "Page-editchat", {"uuid": settingsController.settings.uuid});
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
          children: buildFormList(context, controller),
        );
      }),
    );
  }

  List<Widget> buildFormList(
      BuildContext context, ChatListController controller) {
    List<Widget> widgets = [];
    widgets.add(const Divider());
    widgets.add(ListTile(
      dense: true,
      title: Text(
        'Session Name'.tr,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ));
    widgets.add(Padding(
      padding: const EdgeInsets.only(left: 20, top: 0, bottom: 10, right: 10),
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
    ));
    if (controller.currentSession.modelType == ModelType.chat.name) {
      widgets.add(ListTile(
        dense: true,
        title: Text(
          'Prompt'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ));
      widgets.add(Padding(
        padding: const EdgeInsets.only(left: 20, top: 0, bottom: 10, right: 10),
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
      ));
      widgets.add(ListTile(
        dense: true,
        title: Text(
          'temperature'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ));
      widgets.add(SliderTheme(
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
      ));
      widgets.add(ListTile(
        dense: true,
        title: Text(
          'History Message'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ));
      widgets.add(SliderTheme(
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
          label: controller.currentSession.maxContextMsgCountLabel,
        ),
      ));
    }

    widgets.add(ListTile(
      dense: true,
      title: Text(
        'Model'.tr,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ));

    widgets.add(GroupedBottomSheetSwitcherComponent(
        title: 'Model',
        subTitle: controller.currentSession.model.toUpperCase(),
        selectedValue: controller.currentSession.model,
        options: getGroupedModelOptions(),
        leadingIcon: Icons.smart_toy_outlined,
        onTapCallback: (value) {
          // controller.currentSession.model = value;
          controller.currentModelName = value;
          controller.update();
        }));
    widgets.add(Container(
      padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
      child: Card(
        elevation: 5,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          padding:
              const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          child: Text("model intro".tr),
        ),
      ),
    ));
    widgets.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: () {
              controller.saveSession(controller.currentSession);
              chatListController.update();
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
    ));
    return widgets;
  }
}

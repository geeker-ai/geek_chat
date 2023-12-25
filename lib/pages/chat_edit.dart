import 'package:flutter/material.dart';
// import 'package:geek_chat/components/settings/bottom_sheet_switcher.dart';
import 'package:geek_chat/components/settings/grouped_bottom_sheet_switcher.dart';
import 'package:geek_chat/controller/chat_session_controller.dart';
import 'package:geek_chat/controller/chat_session_edit_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/controller/settings_server_controller.dart';
import 'package:geek_chat/controller/tracker_controller.dart';
import 'package:geek_chat/models/bottom_switcher_model.dart';
import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/models/server.dart';
import 'package:geek_chat/util/app_constants.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class ChatEditPage extends StatelessWidget {
  ChatEditPage({super.key});

  SettingsController settingsController = Get.find<SettingsController>();
  SettingsServerController settingsServerController = Get.find();
  TrackerController tracker = Get.find();
  Logger logger = Get.find();
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController promptEditingController = TextEditingController();

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
    AiModel aiModel = AppConstants.getAiModel("gpt-3.5-turbo");
    String modelName = aiModel.modelName;
    if (chatSessionController.currentSessionId.isNotEmpty) {
      modelName = chatSessionController.currentSession.model;
    }
    AiModel currentAiModel = AppConstants.getAiModel(modelName);
    List<GroupedBottomSwitcherOption> options = [];
    ProviderModel providerModel = AppConstants.getProvider(
        settingsServerController.defaultServer.provider);
    for (AiGroup group in settingsController.aiGroups) {
      // options.add(value)
      GroupedBottomSwitcherOption gOptions = GroupedBottomSwitcherOption(
          groupName: group.groupName, groupDesc: group.groupDesc);

      for (AiModel model in settingsController.getModelsByType(group.aitype)) {
        bool disabled = false;
        if (!providerModel.supportedModels.contains(model.modelName)) {
          disabled = true;
        }
        if (isEdit) {
          if (chatSessionController.currentSession.modelType !=
                  model.modelType.name ||
              currentAiModel.aiType != model.aiType) {
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

  ChatSessionController chatSessionController =
      Get.find<ChatSessionController>();

  @override
  Widget build(BuildContext context) {
    // ChatSessionEditController chatSessionEditController = ChatSessionEditController(editSession: editSession)
    var data = Get.parameters;
    // var options = getModelOptions();
    ChatSessionEditController chatSessionEditController = Get.find();

    if (data['opt'] == 'new') {
      // chatSessionController.createNewSession();
      ProviderModel providerModel = AppConstants.getProvider(
          settingsServerController.defaultServer.provider);

      chatSessionEditController.session = chatSessionController.newSession(
          modelName: providerModel.supportedModels.first);
      isEdit = false;
      chatSessionEditController.isEdit = isEdit;
      tracker.trackEvent(
          "Page-newchat", {"uuid": settingsController.settings.uuid});
    } else {
      isEdit = true;
      chatSessionEditController.isEdit = isEdit;
      // chatSessionController.getSessionBysid(data['sid']!);
      chatSessionEditController.session =
          chatSessionController.getSessionBysid(data['sid']!).copyWith();
      tracker.trackEvent(
          "Page-editchat", {"uuid": settingsController.settings.uuid});
    }

    titleEditingController.text = chatSessionEditController.session.name;
    promptEditingController.text =
        chatSessionEditController.session.promptContent;

    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<ChatSessionEditController>(builder: (controller) {
          return Text(getTitle(data['opt']).tr);
        }),
      ),
      body: GetBuilder<ChatSessionEditController>(builder: (controller) {
        return ListView(
          padding: const EdgeInsets.only(
              left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
          children: buildFormList(context, controller),
        );
      }),
    );
  }

  List<Widget> buildFormList(
      BuildContext context, ChatSessionEditController controller) {
    AiModel aiModel = AppConstants.getAiModel(controller.session.model);
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
        // initialValue: titleEditingController.text,
        controller: titleEditingController,
        decoration: InputDecoration(
          labelText: 'Session Name'.tr,
          filled: false,
        ),
        onChanged: (value) {
          // controller.settings.apiKey = value;
          controller.session.name = value;
          // titleEditingController.text = value;
          // controller.update();
        },
      ),
    ));
    if (controller.session.modelType == ModelType.chat.name) {
      if (aiModel.disablePrompt != null && aiModel.disablePrompt != true) {
        widgets.add(ListTile(
          dense: true,
          title: Text(
            'Prompt'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ));
        widgets.add(Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 0, bottom: 10, right: 10),
          child: TextFormField(
            // initialValue: controller.currentSession.promptContent,
            controller: promptEditingController,
            decoration: const InputDecoration(
              // labelText: 'Prompt'.tr,
              filled: false,
            ),
            minLines: 4,
            maxLines: 4,
            onChanged: (value) {
              controller.session.promptContent = value;
              // promptEditingController.text = value;
              // controller.update();
            },
          ),
        ));
      }

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
          value: controller.session.temperature,
          max: 1,
          min: 0,
          divisions: 10,
          onChanged: (value) {
            controller.session.temperature = value;
            controller.update();
          },
          label: controller.session.temperature.toString(),
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
            controller.session.maxContextMsgCount = count;
            controller.update();
          },
          value: controller.session.maxContextMsgCount.toDouble(),
          min: 0,
          max: 22,
          divisions: 22,
          label: controller.session.maxContextMsgCountLabel,
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
        subTitle: controller.session.model.toUpperCase(),
        selectedValue: controller.session.model,
        options: getGroupedModelOptions(),
        leadingIcon: Icons.smart_toy_outlined,
        onTapCallback: (value) {
          // controller.currentSession.model = value;
          // controller.currentModelName = value;
          // controller.switchSessionModel(value);
          controller.switchSessionModel(value);
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
              chatSessionController.saveSession(controller.session);
              chatSessionController.reloadSessions();
              chatSessionController.update();
              Get.back();
              showCustomToast(
                  title: "Saved successfully!".tr, context: context);
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

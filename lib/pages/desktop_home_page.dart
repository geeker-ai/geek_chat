import 'package:flutter/material.dart';
import 'package:geek_chat/components/chat/chat_list_menu_item.dart';
import 'package:geek_chat/components/chat/menu_button.dart';
import 'package:geek_chat/components/desktop_main_right_component.dart';
import 'package:geek_chat/controller/chat_session_controller.dart';
import 'package:geek_chat/controller/chat_message_controller.dart';
import 'package:geek_chat/controller/question_input_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/controller/settings_server_controller.dart';
import 'package:geek_chat/controller/tracker_controller.dart';
import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/models/session.dart';
import 'package:geek_chat/util/input_submit_util.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class DesktopHomePage extends StatelessWidget {
  DesktopHomePage({super.key}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (settingsController.needSettings) {
        Get.toNamed("/dsettings");
      }
    });
  }

  ChatSessionController chatSessionController = Get.find();
  SettingsController settingsController = Get.find<SettingsController>();
  ChatMessageController chatMessageController =
      Get.find<ChatMessageController>();
  final TrackerController tracker = Get.find();
  final QuestionInputController questionInputController = Get.find();
  final SettingsServerController settingsServerController = Get.find();

  Logger logger = Get.find();

  onQuestionInputSubmit() async {
    logger.d(
        "onQuestionInputSubmit called: ${chatSessionController.currentSession.sid}");
    logger.d(
        "question input: ${questionInputController.questionInputModel.toJson()}");
    // if (context != null) {
    //   LoadingProgress.start(context);
    // }
    if (settingsServerController.defaultServer.provider == "openai" ||
        settingsServerController.defaultServer.provider == "geekerchat") {
      if (chatSessionController.currentSession.modelType ==
          ModelType.image.name) {
        await InputSubmitUtil.instance.submitImageModel(
            chatMessageController,
            chatSessionController,
            questionInputController,
            settingsServerController);
      } else if (chatSessionController.currentSession.modelType ==
          ModelType.chat.name) {
        await InputSubmitUtil.instance.submitChatModel(
            chatMessageController,
            chatSessionController,
            questionInputController,
            settingsServerController);
      } else if (chatSessionController.currentSession.modelType ==
          ModelType.text.name) {
        // TODO process text model
      }
      questionInputController.clear();
      questionInputController.update();
    } else if (settingsServerController.defaultServer.provider == "azure") {
      if (chatSessionController.currentSession.modelType ==
          ModelType.chat.name) {
        await InputSubmitUtil.instance.submitAzureChatModel(
            chatMessageController,
            chatSessionController,
            questionInputController,
            settingsServerController);
      }
      questionInputController.clear();
      questionInputController.update();
    }

    // if (context != null) {
    //   LoadingProgress.stop(context);
    // }
  }

  List<Widget> getLeftMenus(SettingsServerController controller) {
    List<Widget> leftMenus = [
      LeftMenuButtonComponent(
        title: "Prompts".tr,
        onPressed: () {
          Get.toNamed("/prompts");
        },
        icon: Icons.smart_toy_outlined,
      ),
      LeftMenuButtonComponent(
        title: "Settings".tr,
        onPressed: () {
          Get.toNamed("/dsettings")?.then((value) {
            controller.update(['subscription']);
          });
        },
        icon: Icons.settings,
      ),
      // getPriceMenu(),
      LeftMenuButtonComponent(
        title: "${'About'.tr}(v${settingsController.packageInfo.version})",
        onPressed: () {
          Get.toNamed("/about");
          // Get.snackbar(
          //   'Sorry!'.tr,
          //   'This feature will coming soon!'.tr,
          //   duration: const Duration(seconds: 2),
          //   snackPosition: SnackPosition.TOP,
          // );
        },
        icon: Icons.info_outline,
      ),
    ];
    return leftMenus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4, left: 8, bottom: 10),
        child: Row(
          children: [
            SizedBox(
              width: 240,
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3))),
                      onPressed: () {
                        Get.toNamed('/editchat',
                            parameters: {'opt': 'new', 'sid': ''});
                      },
                      label: Text("New Chat".tr),
                      icon: const Icon(Icons.add),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: GetBuilder<ChatSessionController>(
                        builder: (controller) {
                      return ListView.builder(
                          itemCount: controller.sessions.length,
                          controller: ScrollController(),
                          itemBuilder: (BuildContext ctxt, int index) {
                            return ChatListMenuItemComponent(
                                session: controller.sessions.elementAt(index),
                                onTap: (String sid) {
                                  controller.switchSession(sid);
                                  controller.update();
                                  tracker.trackEvent("switchSession", {
                                    "uuid": settingsController.settings.uuid
                                  });
                                },
                                currentSession: controller.currentSession,
                                onDelete: (SessionModel session) {
                                  chatMessageController
                                      .cleanSessionMessages(session.sid);
                                  controller.remove(session);
                                  controller.reloadSessions();
                                  controller.update();
                                  tracker.trackEvent("removeSession", {
                                    "uuid": settingsController.settings.uuid
                                  });
                                });
                          });
                    }),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 5, right: 10),
                    child: Divider(),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: GetBuilder<SettingsServerController>(
                        id: 'subscription',
                        builder: (controler) {
                          return Column(children: getLeftMenus(controler));
                        }),
                  ),
                ],
              ),
            ),
            Container(
              width: 0.5,
              // color: Colors.black,
            ),
            Expanded(
              child: GetBuilder<ChatSessionController>(builder: (controller) {
                return chatSessionController.currentSessionId.isEmpty
                    ? const Text("Please select or create a chat!")
                    : DeskTopMainRightComponent(
                        sid: chatSessionController.currentSession.sid,
                        questionInputController: questionInputController,
                        onQuestionSubmit: onQuestionInputSubmit,
                      );
              }),
            )
          ],
        ),
      ),
    );
  }
}

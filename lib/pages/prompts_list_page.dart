import 'dart:async';

// import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:geek_chat/controller/chat_list_controller.dart';
import 'package:geek_chat/controller/main_controller.dart';
import 'package:geek_chat/models/prompts.dart';
import 'package:geek_chat/models/session.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class PromptsListPage extends StatelessWidget {
  // EventBus eventBus = Get.find();
  Logger logger = Get.find();
  late StreamSubscription eventSub;
  PromptsListPage({super.key}) {
    // eventSub = eventBus.on<LanguageModel>().listen((event) {
    //   mainController.initPrompts().then((value) {
    //     logger.d("init prompts finished!");
    //     mainController.update();
    //     eventSub.cancel();
    //   });
    // });
  }

  MainController mainController = Get.find();
  ChatListController chatListController = Get.find();

  double getFittedCardWidth(BuildContext context) {
    double width = 330;
    double parentWidgetWidth = MediaQuery.of(context).size.width;
    // if (parentWidgetWidth / 3)
    for (int i = 1; i <= 5; i++) {
      if ((parentWidgetWidth / i - 330) < 50) {
        width = (parentWidgetWidth / i) - 2 * i;
        break;
      }
    }
    return width;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prompts".tr),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        child: GetBuilder<MainController>(
          builder: (controller) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(left: 10, right: 0),
              child: Wrap(
                children: [
                  for (PromptModel promptModel in controller.prompts)
                    Container(
                      width: getFittedCardWidth(context),
                      padding: const EdgeInsets.only(bottom: 10, right: 10),
                      child: Card(
                        elevation: 5,
                        child: InkWell(
                          onTap: () {
                            SessionModel sessionModel =
                                chatListController.createSession(
                              name: promptModel.name,
                              prompt: promptModel.prompt,
                            );
                            // // chatListController.save();
                            chatListController.saveSession(sessionModel);
                            // controller.navIndex = 0;
                            controller.update();
                            chatListController.update();
                            Get.back();
                            Get.toNamed('/chat',
                                parameters: {'sid': sessionModel.sid});
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  promptModel.name,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  promptModel.prompt,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

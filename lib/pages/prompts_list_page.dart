import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:geek_chat/controller/chat_list_controller.dart';
import 'package:geek_chat/controller/main_controller.dart';
import 'package:geek_chat/models/language.dart';
import 'package:geek_chat/models/prompts.dart';
import 'package:geek_chat/models/session.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class PromptsListPage extends StatelessWidget {
  EventBus eventBus = Get.find();
  Logger logger = Get.find();
  PromptsListPage({super.key}) {
    eventBus.on<LanguageModel>().listen((event) {
      mainController.initPrompts().then((value) {
        logger.d("init prompts finished!");
        mainController.update();
      });
    });
  }

  MainController mainController = Get.find();
  ChatListController chatListController = Get.find();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();
    return Scaffold(
      appBar: AppBar(
        title: Text("Prompts".tr),
      ),
      body: GetBuilder<MainController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(left: 10),
            child: Wrap(
              children: [
                for (PromptModel promptModel in controller.prompts)
                  Container(
                    width: 330,
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
                          // Get.toNamed('/chat',
                          //     parameters: {'sid': sessionModel.sid});
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                promptModel.name,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
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
    );
  }
}

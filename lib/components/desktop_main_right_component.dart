import 'package:flutter/material.dart';
import 'package:geek_chat/components/chat/message_block.dart';
import 'package:geek_chat/controller/chat_list_controller.dart';
import 'package:geek_chat/controller/chat_message_controller.dart';
import 'package:geek_chat/models/session.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class DeskTopMainRightComponent extends StatelessWidget {
  DeskTopMainRightComponent({super.key, required this.sid}) {
    chatMessageController = Get.put(ChatMessageController());
    // session = chatListController.getSessionBysid(sid!);
  }

  late ChatMessageController chatMessageController;
  ChatListController chatListController = Get.find<ChatListController>();

  TextEditingController textEditingController = TextEditingController();

  String sid;

  @override
  Widget build(BuildContext context) {
    SessionModel session = chatListController.currentSession;
    chatMessageController.findBySessionId(sid);

    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      child: Column(
        children: [
          // ConstrainedBox(constraints: BoxConstraints(minWidth: 400)),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 20, top: 0),
            alignment: Alignment.centerLeft,
            height: 50,
            width: double.infinity,
            child: Row(
              children: [
                Text(
                  session.name,
                  style: const TextStyle(fontSize: 18),
                ),
                TextButton.icon(
                  onPressed: () {
                    Get.toNamed('/editchat',
                        parameters: {'opt': 'edit', 'sid': session.sid});
                  },
                  icon: const Icon(Icons.tune),
                  label: Text(session.model),
                ),
                const Expanded(
                  child: Text(''),
                ),
                IconButton(
                  onPressed: () {
                    Get.snackbar(
                      'Sorry!'.tr,
                      'This feature will coming soon!'.tr,
                      duration: const Duration(seconds: 2),
                      snackPosition: SnackPosition.TOP,
                    );
                  },
                  icon: const Icon(Icons.cleaning_services),
                ),
                IconButton(
                  onPressed: () {
                    Get.snackbar(
                      'Sorry!'.tr,
                      'This feature will coming soon!'.tr,
                      duration: const Duration(seconds: 2),
                      snackPosition: SnackPosition.TOP,
                    );
                  },
                  icon: const Icon(Icons.sync),
                ),
                IconButton(
                  onPressed: () {
                    Get.snackbar(
                      'Sorry!'.tr,
                      'This feature will coming soon!'.tr,
                      duration: const Duration(seconds: 2),
                      snackPosition: SnackPosition.TOP,
                    );
                  },
                  icon: const Icon(Icons.save),
                )
                // IconButton(onPressed: () {}, icon: Icon(Icons.edit))
              ],
            ),
          ),
          Expanded(
            child: GetBuilder<ChatMessageController>(builder: (controller) {
              return ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                controller: ScrollController(),
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext ctxt, int index) {
                  return MessageContent(
                    message: controller.messages.elementAt(index),
                    session: chatListController.currentSession,
                  );
                },
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: GetBuilder<ChatMessageController>(builder: (controller) {
              textEditingController.text = controller.inputQuestion;
              return Container(
                padding: const EdgeInsets.only(top: 1),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        minLines: 1,
                        maxLines: 3,
                        textInputAction: TextInputAction.go,
                        decoration: const InputDecoration(
                          filled: false,
                          suffixIcon: Icon(Icons.send),
                        ),
                        onChanged: (value) {
                          controller.inputQuestion = value;
                        },
                        onSubmitted: (String value) {
                          // onSubmit();
                          controller.submit(sid);
                          // controller.update();
                        },
                        onTap: () {
                          //
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geek_chat/components/chat/message_block.dart';
import 'package:geek_chat/controller/chat_list_controller.dart';
import 'package:geek_chat/controller/chat_message_controller.dart';
import 'package:geek_chat/models/session.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class ChatMessagePage extends StatelessWidget {
  late ChatMessageController chatMessageController;
  Logger logger = Get.find<Logger>();
  ChatMessagePage({super.key}) {
    var data = Get.parameters;
    sid = data['sid'];
    logger.d("ChatMessageController: $sid ");
    chatMessageController = Get.put(ChatMessageController());
    session = chatListController.getSessionBysid(sid!);
    chatMessageController.findBySessionId(sid);
  }

  late SessionModel session;

  // late SessionModel session;
  late String? sid;

  ChatListController chatListController = Get.find<ChatListController>();
  TextEditingController textEditingController = TextEditingController();
  // final ChatMessageController chatMessageController = ChatMessageController();

  void scrollToBottom() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  ScrollController scrollController = ScrollController();

  final double radius = 14;

  @override
  Widget build(BuildContext context) {
    // print("messages.length: ${messages.length}");
    // SessionModel session = chatListController.getSessionBysid(sid);
    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<ChatListController>(builder: (controller) {
          return Text(session.name);
        }),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GetBuilder<ChatMessageController>(builder: (controller) {
                return ListView.builder(
                  reverse: true,
                  itemCount: controller.messages.length,
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return MessageBlock(
                        message: controller.messages.elementAt(index));
                  },
                );
              }),
            ),
            Container(
              // width: MediaQuery.of(context).size.width,
              // padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
              padding:
                  const EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 0,
                    color: Colors.transparent,
                  ),
                ),
              ),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  child:
                      GetBuilder<ChatMessageController>(builder: (controller) {
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
                              decoration: const InputDecoration(filled: false),
                              onChanged: (value) {
                                controller.inputQuestion = value;
                              },
                              onSubmitted: (String value) {
                                // onSubmit();
                                controller.submit(sid ?? '');
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
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

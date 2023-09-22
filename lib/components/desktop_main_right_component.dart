import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geek_chat/components/chat/message_block.dart';
import 'package:geek_chat/controller/chat_list_controller.dart';
import 'package:geek_chat/controller/chat_message_controller.dart';
import 'package:geek_chat/controller/chat_message_scroll_controller.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/session.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class DeskTopMainRightComponent extends StatelessWidget {
  DeskTopMainRightComponent({super.key, required this.sid}) {
    chatMessageController = Get.put(ChatMessageController());

    /// init right scroll button
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.addListener(() {
        scrollButtonListener();
      });
      scrollButtonListener();
    });
  }

  void scrollButtonListener() {
    final extentAfter = scrollController.position.extentAfter;
    bool showGotoTopBtnLocal = chatMessageScrollController.showGotoTopBtn;
    bool showGotoBottomBtnLocal = chatMessageScrollController.showGotoBottomBtn;
    if (extentAfter < 10) {
      showGotoTopBtnLocal = false;
    } else {
      showGotoTopBtnLocal = true;
    }

    if (scrollController.position.maxScrollExtent - extentAfter <= 10) {
      showGotoBottomBtnLocal = false;
    } else {
      showGotoBottomBtnLocal = true;
    }
    if (showGotoBottomBtnLocal !=
        chatMessageScrollController.showGotoBottomBtn) {
      chatMessageScrollController.showGotoBottomBtn = showGotoBottomBtnLocal;
      chatMessageScrollController.update();
    }
    if (showGotoTopBtnLocal != chatMessageScrollController.showGotoTopBtn) {
      chatMessageScrollController.showGotoTopBtn = showGotoTopBtnLocal;
      chatMessageScrollController.update();
    }
  }

  void scrollToTop() async {
    do {
      double delta =
          scrollController.position.maxScrollExtent - scrollController.offset;
      double to = 0;
      // double ratio = delta / 1000 - 2;
      if (delta > 500) {
        to = scrollController.offset + delta / 2.5;
      } else {
        to = scrollController.position.maxScrollExtent;
      }

      await scrollController.animateTo(
        to,
        duration: const Duration(microseconds: 200),
        curve: Curves.linear,
      );
    } while (
        scrollController.position.maxScrollExtent - scrollController.offset >
            50);
  }

  void scrollToBottom() {
    logger.d("scroll to bottom ${scrollController.position.minScrollExtent}");
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.linear,
    );
  }

  Logger logger = Get.find<Logger>();

  late ChatMessageController chatMessageController;
  ChatListController chatListController = Get.find<ChatListController>();

  TextEditingController textEditingController = TextEditingController();

  ScrollController scrollController = ScrollController();
  ChatMessageScrollController chatMessageScrollController =
      Get.put(ChatMessageScrollController());

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
              return Stack(
                fit: StackFit.expand,
                alignment: Alignment.topLeft,
                children: [
                  ListView.builder(
                    key: chatMessageScrollController.listViewKey,
                    reverse: true,
                    itemCount: controller.messages.length,
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return MessageContent(
                          message: controller.messages.elementAt(index),
                          session: chatListController.currentSession,
                          onQuote: (MessageModel message) {
                            controller.inputQuestion =
                                "\"${message.content}\" \n ---------------------- \n";
                            controller.update();
                          },
                          onDelete: (MessageModel message) {
                            //
                          });
                    },
                  ),
                  MessageListScrollBtnComponent(
                    scrollToTop: scrollToTop,
                    scrollToBottom: scrollToBottom,
                  )
                ],
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
                        maxLines: 5,
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

// ignore: must_be_immutable
class MessageListScrollBtnComponent extends StatelessWidget {
  MessageListScrollBtnComponent(
      {super.key, required this.scrollToTop, required this.scrollToBottom});

  Function scrollToTop;
  Function scrollToBottom;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatMessageScrollController>(builder: (controller) {
      // controller.initScrollButton();
      return Positioned(
        bottom: 20,
        right: 5,
        child: Column(
          children: [
            Opacity(
              opacity: controller.showGotoTopBtn ? 1 : 0,
              child: IconButton(
                onPressed: controller.showGotoTopBtn
                    ? () {
                        scrollToTop();
                      }
                    : null,
                icon: const Icon(Icons.arrow_circle_up_outlined),
              ),
            ),
            Opacity(
              opacity: controller.showGotoBottomBtn ? 1 : 0,
              child: IconButton(
                onPressed: controller.showGotoBottomBtn
                    ? () {
                        scrollToBottom();
                      }
                    : null,
                icon: const Icon(Icons.arrow_circle_down_outlined),
              ),
            ),
          ],
        ),
      );
    });
  }
}

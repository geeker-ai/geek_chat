import 'package:flutter/material.dart';
import 'package:geek_chat/components/chat/message_block.dart';
import 'package:geek_chat/components/chat/question_input_component.dart';
import 'package:geek_chat/controller/chat_session_controller.dart';
import 'package:geek_chat/controller/chat_message_controller.dart';
import 'package:geek_chat/controller/chat_message_scroll_controller.dart';
import 'package:geek_chat/controller/question_input_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/session.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class DeskTopMainRightComponent extends StatelessWidget {
  DeskTopMainRightComponent(
      {super.key,
      required this.sid,
      required this.questionInputController,
      required this.onQuestionSubmit}) {
    chatMessageController = Get.find<ChatMessageController>();

    /// init right scroll button
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.addListener(() {
        scrollButtonListener();
      });
      scrollButtonListener();
      questionInputController.inputFocus.requestFocus();
    });
  }

  Function onQuestionSubmit;

  QuestionInputController questionInputController;

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
      if (delta > 50) {
        to = scrollController.offset + delta / 7;
      } else {
        to = scrollController.position.maxScrollExtent;
      }

      await scrollController.animateTo(
        to,
        duration: const Duration(microseconds: 170),
        curve: Curves.linear,
      );
    } while (
        scrollController.position.maxScrollExtent - scrollController.offset >
            20);
  }

  Future<void> scrollToBottom({animate = true}) async {
    int duration = 10;
    if (animate) {
      duration = 500;
    }

    await scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: duration),
      curve: Curves.linear,
    );
  }

  Logger logger = Get.find<Logger>();

  late ChatMessageController chatMessageController;
  ChatSessionController chatSessionController =
      Get.find<ChatSessionController>();

  ScrollController scrollController = ScrollController();
  ChatMessageScrollController chatMessageScrollController =
      Get.put(ChatMessageScrollController());

  SettingsController settingsController = Get.find<SettingsController>();

  String sid;

  @override
  Widget build(BuildContext context) {
    SessionModel session = chatSessionController.currentSession;
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
                  label: Text(session.model.toUpperCase()),
                ),
                const Expanded(
                  child: Text(''),
                ),
                IconButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: "Clean Session".tr,
                      onCancel: () {
                        Get.back();
                      },
                      onConfirm: () {
                        // onDelete(message);
                        chatMessageController.cleanSessionMessages(
                            chatSessionController.currentSession.sid);
                        chatMessageController.update();
                        Get.back();
                      },
                      textCancel: "Cancel".tr,
                      textConfirm: "Confirm".tr,
                      middleText: "Confirm clean session?".tr,
                      radius: 5,
                    );
                  },
                  icon: const Icon(Icons.cleaning_services),
                ),
                // IconButton(
                //   onPressed: () {
                //   },
                //   icon: const Icon(Icons.sync),
                // ),
                // IconButton(
                //   onPressed: () {
                //     Get.snackbar(
                //       'Sorry!'.tr,
                //       'This feature will coming soon!'.tr,
                //       duration: const Duration(seconds: 2),
                //       snackPosition: SnackPosition.TOP,
                //     );
                //   },
                //   icon: const Icon(Icons.save),
                // )
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
                    reverse: true,
                    itemCount: controller.messages.length,
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return MessageContent(
                          key: GlobalObjectKey(
                              controller.messages.elementAt(index).msgId),
                          message: controller.messages.elementAt(index),
                          deviceType: settingsController.deviceType,
                          session: chatSessionController.currentSession,
                          onQuote: (MessageModel message) {
                            if (controller
                                .isMessagesTooLong(controller.quoteMessages)) {
                              showCustomToast(
                                  title: "Too many quote messages".tr,
                                  context: context);
                            } else {
                              controller.addQuoteMessage(message);
                              controller.update();
                            }
                            questionInputController.inputFocus.requestFocus();
                          },
                          onDelete: (MessageModel message) {
                            //
                            controller.removeMessage(message);
                            controller.update();
                          },
                          moveTo: (MessageModel msg) {
                            logger.d("move to: ${msg.msgId}");
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
          QuestionInputPanelCompoent(
            sid: sid,
            scrollToBottom: scrollToBottom,
            // questionInputFocus: questionInputFocus,
            session: session,
            onQuestionInputSubmit: onQuestionSubmit,
            questionInputController: questionInputController,
            settingsController: settingsController,
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

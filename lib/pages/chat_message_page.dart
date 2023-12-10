import 'package:flutter/material.dart';
import 'package:geek_chat/components/chat/message_block.dart';
import 'package:geek_chat/components/chat/question_input_component.dart';
import 'package:geek_chat/controller/chat_session_controller.dart';
import 'package:geek_chat/controller/chat_message_controller.dart';
import 'package:geek_chat/controller/question_input_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/controller/settings_server_controller.dart';
import 'package:geek_chat/controller/tracker_controller.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/models/session.dart';
import 'package:geek_chat/util/input_submit_util.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class ChatMessagePage extends StatelessWidget {
  late ChatMessageController chatMessageController;
  SettingsController settingsController = Get.find();
  Logger logger = Get.find<Logger>();
  TrackerController tracker = Get.find();
  ChatMessagePage({super.key}) {
    var data = Get.parameters;
    sid = data['sid'];
    logger.d("ChatMessageController: $sid ");
    chatMessageController = Get.find<ChatMessageController>();
    session = chatSessionController.getSessionBysid(sid!);
    chatMessageController.findBySessionId(sid);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // scrollController.addListener(() {
      //   scrollButtonListener();
      // });
      // scrollButtonListener();
      // questionInputController.inputFocus.requestFocus();
    });
  }

  late SessionModel session;

  // late SessionModel session;
  late String? sid;

  ChatSessionController chatSessionController =
      Get.find<ChatSessionController>();
  TextEditingController textEditingController = TextEditingController();

  scrollToBottom({animate = true}) async {
    int duration = 10;
    if (animate) {
      duration = 500;
    }
    await scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: duration), curve: Curves.easeInOut);
  }

  ScrollController scrollController = ScrollController();
  QuestionInputController questionInputController = Get.find();
  SettingsServerController settingsServerController = Get.find();

  final double radius = 14;

  Future<void> onSubmit(ChatMessageController controller) async {
    await scrollToBottom(animate: false);
    if (session.modelType == ModelType.image.name) {
      await InputSubmitUtil.instance.submitImageModel(
          chatMessageController,
          chatSessionController,
          questionInputController,
          settingsServerController);
      // return;
    } else if (session.modelType == ModelType.chat.name) {
      await InputSubmitUtil.instance.submitChatModel(
          chatMessageController,
          chatSessionController,
          questionInputController,
          settingsServerController);
    }
    // controller.submit(sid ?? '', onDone: () {
    //   chatSessionController
    //       .updateSessionLastEdit(chatSessionController.currentSession);
    //   chatSessionController.update();
    // }, onError: () {
    //   chatSessionController
    //       .updateSessionLastEdit(chatSessionController.currentSession);
    //   chatSessionController.update();
    // });
    // controller.update();
    tracker.trackEvent("chat", {"uuid": settingsController.settings.uuid});
  }

  @override
  Widget build(BuildContext context) {
    // print("messages.length: ${messages.length}");
    // SessionModel session = chatListController.getSessionBysid(sid);
    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<ChatSessionController>(builder: (controller) {
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
                    // return MessageBlock(
                    //     message: controller.messages.elementAt(index));
                    return MessageContent(
                        message: controller.messages.elementAt(index),
                        deviceType: settingsController.deviceType,
                        session: session,
                        onQuote: (MessageModel message) {},
                        onDelete: (MessageModel message) {},
                        moveTo: (MessageModel message) {});
                  },
                );
              }),
            ),
            Container(
              child: QuestionInputPanelCompoent(
                sid: sid!,
                scrollToBottom: scrollToBottom,
                questionInputController: questionInputController,
                session: chatSessionController.currentSession,
                onQuestionInputSubmit: () async {
                  logger.d("onSubumit");
                  if (session.modelType == ModelType.image.name) {
                    // onSubmit(controller);
                    logger.d("image model submited");
                    await onSubmit(chatMessageController);
                  } else {
                    await onSubmit(chatMessageController);
                  }
                },
                settingsController: settingsController,
              ),
            ),
            // Container(
            //   // width: MediaQuery.of(context).size.width,
            //   // padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
            //   padding:
            //       const EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
            //   decoration: const BoxDecoration(
            //     border: Border(
            //       top: BorderSide(
            //         width: 0,
            //         color: Colors.transparent,
            //       ),
            //     ),
            //   ),
            //   child:
            //       Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            //     Expanded(
            //       child:
            //           GetBuilder<ChatMessageController>(builder: (controller) {
            //         textEditingController.text = controller.inputQuestion;
            //         return Container(
            //           padding: const EdgeInsets.only(top: 1),
            //           child: Row(
            //             children: [
            //               Expanded(
            //                 child: TextField(
            //                   controller: textEditingController,
            //                   minLines: 1,
            //                   maxLines: 3,
            //                   textInputAction: TextInputAction.go,
            //                   decoration: InputDecoration(
            //                       filled: false,
            //                       suffixIcon: IconButton(
            //                           onPressed: () async {
            //                             onSubmit(controller);
            //                           },
            //                           icon: const Icon(Icons.send))),
            //                   onChanged: (value) {
            //                     controller.inputQuestion = value;
            //                   },
            //                   onSubmitted: (String value) async {
            //                     // onSubmit();
            //                     onSubmit(controller);
            //                   },
            //                   onTap: () {
            //                     //
            //                   },
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       }),
            //     ),
            //   ]),
            // ),
          ],
        ),
      ),
    );
  }
}

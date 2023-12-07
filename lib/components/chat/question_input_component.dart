import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geek_chat/controller/chat_session_controller.dart';
import 'package:geek_chat/controller/chat_message_controller.dart';
import 'package:geek_chat/controller/question_input_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/controller/tracker_controller.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/session.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class QuestionInputPanelCompoent extends StatelessWidget {
  QuestionInputPanelCompoent({
    super.key,
    required this.sid,
    required this.scrollToBottom,
    required this.questionInputFocus,
    required this.session,
    required this.questionInputController,
    required this.onSubmit,
  });

  String sid;
  SessionModel session;
  Function scrollToBottom;
  Function onSubmit;
  FocusNode questionInputFocus;
  QuestionInputController questionInputController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: GetBuilder<ChatMessageController>(builder: (controller) {
        return Container(
          padding: const EdgeInsets.only(top: 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 2, right: 2),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          QuestionInputComponent(
                            sid: sid,
                            scrollToBottom: scrollToBottom,
                            questionInputFocus: questionInputFocus,
                            session: session,
                          ),
                          QuoteMessagesComponent(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 5, bottom: 3),
                child: Text(
                  "input tips".tr,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ignore: must_be_immutable
class QuestionInputComponent extends StatelessWidget {
  QuestionInputComponent({
    super.key,
    required this.sid,
    required this.scrollToBottom,
    required this.questionInputFocus,
    required this.session,
  });

  String sid;
  Function scrollToBottom;
  FocusNode questionInputFocus;
  SessionModel session;

  TextEditingController textEditingController = TextEditingController();
  ChatSessionController chatSessionController = Get.find();
  SettingsController settingsController = Get.find();
  Logger logger = Get.find();
  ChatMessageController chatMessageController = Get.find();
  final TrackerController tracker = Get.find();

  KeyEventResult onKey(FocusNode focusNode, RawKeyEvent event) {
    if (event.isKeyPressed(LogicalKeyboardKey.enter) &&
        !event.isShiftPressed &&
        !event.isControlPressed &&
        !event.isAltPressed) {
      logger.d("Enter key is pressed!");
      // process submit
      submit(chatMessageController);
      return KeyEventResult.handled;
    } else if (event.isKeyPressed(LogicalKeyboardKey.enter) &&
        event.isShiftPressed) {
      logger.d("Shit + Enter is pressed!");
      return KeyEventResult.ignored;
    }
    return KeyEventResult.ignored;
  }

  submit(ChatMessageController controller) async {
    await scrollToBottom(animate: false);
    controller.submit(sid, onDone: () {
      chatSessionController
          .updateSessionLastEdit(chatSessionController.currentSession);
      chatSessionController.update();
    }, onError: () {
      chatSessionController
          .updateSessionLastEdit(chatSessionController.currentSession);
      chatSessionController.update();
    });
    tracker.trackEvent("chat", {"uuid": settingsController.settings.uuid});
  }

  @override
  Widget build(BuildContext context) {
    // questionInputFocus.
    // questionInputFocus.attach(context, onKey: onKey);
    questionInputFocus.onKey = onKey;
    // questionInputFocus.requestFocus();
    return GetBuilder<ChatMessageController>(
        id: 'inputQuestion',
        builder: (controller) {
          textEditingController.text = controller.inputQuestion;
          return TextFormField(
            controller: textEditingController,
            focusNode: questionInputFocus,
            minLines: 1,
            maxLines: 5,
            textInputAction: TextInputAction.newline,
            // keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              suffixIcon: IconButton(
                  onPressed: () async {
                    submit(controller);
                  },
                  icon: const Icon(Icons.send)),
            ),
            onChanged: (value) {
              // logger.d("onChanged $value");
              if (controller.isMessagesTooLong(controller.quoteMessages)) {
                showCustomToast(
                    title: "Too many quote messages".tr, context: context);
              }
              controller.inputQuestion = value;
              // controller.update(['inputQuestion']);
            },
            onTap: () {
              //
            },
          );
        });
  }
}

// ignore: must_be_immutable
class QuoteMessagesComponent extends StatelessWidget {
  QuoteMessagesComponent({super.key});

  // ChatSessionController chatSessionController = Get.find();
  ChatMessageController chatMessageController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (chatMessageController.quoteMessages.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Wrap(
        spacing: 3,
        runSpacing: 3,
        direction: Axis.horizontal,
        textDirection: TextDirection.ltr,
        children: [
          for (MessageModel message in chatMessageController.quoteMessages)
            InputChip(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              label: SizedBox(
                width: 150,
                child: Text(
                  message.content,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              deleteIcon: const Icon(Icons.cancel_outlined),
              deleteButtonTooltipMessage: "Delete".tr,
              padding: const EdgeInsets.all(0),
              onDeleted: () {
                chatMessageController.removeQuoteMessage(message);
                chatMessageController.update();
              },
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geek_chat/controller/chat_session_controller.dart';
import 'package:geek_chat/controller/chat_message_controller.dart';
import 'package:geek_chat/controller/question_input_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/controller/tracker_controller.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/model.dart';
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
    // required this.questionInputFocus,
    required this.session,
    required this.questionInputController,
    required this.onQuestionInputSubmit,
  });

  String sid;
  SessionModel session;
  Function scrollToBottom;
  Function onQuestionInputSubmit;
  // FocusNode questionInputFocus;
  QuestionInputController questionInputController;
  Logger logger = Get.find<Logger>();

  bool isImageSession() {
    bool isImage = false;
    if (session.modelType == ModelType.image.name) {
      isImage = true;
    }
    return isImage;
  }

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
              if (isImageSession()) buildImageToolBar(context),
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
                            // questionInputFocus:
                            //     questionInputController.inputFocus,
                            session: session,
                            onQuestionInputSubmit: onQuestionInputSubmit,
                            questionInputController: questionInputController,
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

  Widget buildImageToolBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 2, right: 0, top: 0, bottom: 15),
      child: Wrap(
        children: [
          ImageInputParametersComponent(
            title: "Image Size",
            dropDownlist: questionInputController.imageSizeList,
            defaultValue: questionInputController.defaultImageSize,
            onChanged: (value) {
              questionInputController.questionInputModel.imageParameterSize =
                  value;
              logger.d(
                  "image size: ${questionInputController.questionInputModel.imageParameterSize}");
            },
          ),
          const SizedBox(
            width: 10,
          ),
          ImageInputParametersComponent(
            title: "Image Quality",
            dropDownlist: questionInputController.imageQualityList,
            defaultValue: questionInputController.defaultImageQuality,
            onChanged: (value) {
              questionInputController.questionInputModel.imageParameterQuality =
                  value;
              logger.d(
                  "image size: ${questionInputController.questionInputModel.imageParameterQuality}");
            },
            width: 110,
          ),
          const SizedBox(
            width: 10,
          ),
          ImageInputParametersComponent(
            title: "Image Style",
            dropDownlist: questionInputController.imageStyleList,
            defaultValue: questionInputController.defaultImageStyle,
            onChanged: (value) {
              questionInputController.questionInputModel.imageParameterStyle =
                  value;
              logger.d(
                  "image size: ${questionInputController.questionInputModel.imageParameterStyle}");
            },
            width: 110,
          ),
          // const SizedBox(
          //   width: 10,
          // ),
          // ImageInputParametersComponent(
          //   title: "Image Count",
          //   dropDownlist: questionInputController.imageNList,
          //   defaultValue: questionInputController.defaultImageN,
          //   onChanged: (value) {
          //     questionInputController.questionInputModel.imageParameterN =
          //         int.parse(value);
          //     logger.d(
          //         "image count: ${questionInputController.questionInputModel.imageParameterN}");
          //   },
          //   width: 70,
          // ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ImageInputParametersComponent extends StatelessWidget {
  ImageInputParametersComponent({
    super.key,
    required this.title,
    required this.dropDownlist,
    required this.defaultValue,
    required this.onChanged,
    this.width = 130,
  });
  String title;
  List<String> dropDownlist;
  String defaultValue;
  double width;
  Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 2),
          child: Text(title.tr),
        ),
        const SizedBox(width: 10),
        // select widget
        DropdownMenu<String>(
          enableFilter: false,
          width: width,
          textStyle: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize),
          inputDecorationTheme: InputDecorationTheme(
            // contentPadding: EdgeInsets.all(0),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            labelStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize),
          ),
          initialSelection: defaultValue,
          dropdownMenuEntries:
              dropDownlist.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList(),
          onSelected: (value) {
            onChanged(value);
          },
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class QuestionInputComponent extends StatelessWidget {
  QuestionInputComponent({
    super.key,
    required this.sid,
    required this.scrollToBottom,
    // required this.questionInputFocus,
    required this.session,
    required this.onQuestionInputSubmit,
    required this.questionInputController,
  });

  String sid;
  Function scrollToBottom;
  Function onQuestionInputSubmit;
  // FocusNode questionInputFocus;
  SessionModel session;
  QuestionInputController questionInputController;

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
    if (session.modelType == ModelType.image.name) {
      onQuestionInputSubmit();
      return;
    }
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
    questionInputController.inputFocus.onKey = onKey;
    // questionInputFocus.requestFocus();
    return GetBuilder<ChatMessageController>(
        id: 'inputQuestion',
        builder: (controller) {
          textEditingController.text = controller.inputQuestion;
          return TextFormField(
            controller: textEditingController,
            focusNode: questionInputController.inputFocus,
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
              questionInputController.inputText = value;
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

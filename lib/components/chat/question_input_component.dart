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
import 'package:geek_chat/util/app_constants.dart';
import 'package:geek_chat/util/app_loading_dialog.dart';
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
    required this.settingsController,
  });

  String sid;
  SessionModel session;
  Function scrollToBottom;
  Function onQuestionInputSubmit;
  // FocusNode questionInputFocus;
  QuestionInputController questionInputController;
  SettingsController settingsController;
  Logger logger = Get.find<Logger>();

  bool isImageSession() {
    bool isImage = false;
    if (session.modelType == ModelType.image.name) {
      isImage = true;
    }
    return isImage;
  }

  bool isModelEnableImage() {
    return true;
  }

  Widget buildImageUploader(BuildContext context) {
    AiModel aiModel = AppConstants.getAiModel(session.model);
    // logger.d("aiModel: ${aiModel.enableImage}, ${aiModel.modelName}");
    if (aiModel.enableImage == null) {
      return const SizedBox();
    }
    const IconData upload = IconData(0xe695, fontFamily: 'MaterialIcons');
    Widget widget = const Icon(upload);
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: GetBuilder<QuestionInputController>(builder: (controller) {
        return Container(
          padding: const EdgeInsets.only(top: 1, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isImageSession()) buildImageToolBar(context),
              Row(
                children: [
                  buildImageUploader(context),
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
                          QuoteMessagesComponent(
                            questionInputController: questionInputController,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (settingsController.deviceType.name != DeviceType.small.name)
                Container(
                  padding: const EdgeInsets.only(top: 3, bottom: 3),
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
        runSpacing: 0.5,
        spacing: 0.5,
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
    return Container(
      // decoration: BoxDecoration(
      // border: Border.all(color: Theme.of(context).colorScheme.primary),
      // borderRadius: const BorderRadius.all(Radius.circular(3)),
      // ),
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: Row(
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
              isDense: true,
              isCollapsed: true,
              // contentPadding: EdgeInsets.all(0),
              contentPadding: const EdgeInsets.all(0),
              // constraints: BoxConstraints.tight(const Size.fromHeight(30)),
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
      ),
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
      // focusNode.context
      // logger.d("focusNoe.context: ${focusNode.context}");
      if (focusNode.context != null) {
        logger.d("focusNoe.context: ${focusNode.context}");
        AppLoadingProgress.start(focusNode.context!);
      }
      submit(chatMessageController).then((value) {
        if (focusNode.context != null) {
          AppLoadingProgress.stop(focusNode.context!);
        }
      });
      return KeyEventResult.handled;
    } else if (event.isKeyPressed(LogicalKeyboardKey.enter) &&
        event.isShiftPressed) {
      logger.d("Shit + Enter is pressed!");
      return KeyEventResult.ignored;
    }
    return KeyEventResult.ignored;
  }

  Future<void> submit(ChatMessageController controller) async {
    logger.d("on submit: ${settingsController.deviceType}");
    await scrollToBottom(animate: false);
    if (settingsController.deviceType.name == DeviceType.small.name) {
      await onQuestionInputSubmit();
      // return;
    } else if (session.modelType == ModelType.image.name) {
      await onQuestionInputSubmit();
      // return;
    } else if (session.modelType == ModelType.chat.name) {
      await onQuestionInputSubmit();
    }
    // await scrollToBottom(animate: false);
    // controller.submit(sid, onDone: () {
    //   chatSessionController
    //       .updateSessionLastEdit(chatSessionController.currentSession);
    //   chatSessionController.update();
    // }, onError: () {
    //   chatSessionController
    //       .updateSessionLastEdit(chatSessionController.currentSession);
    //   chatSessionController.update();
    // });
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
          // textEditingController.text = controller.inputQuestion;
          return TextFormField(
            controller: textEditingController,
            // initialValue: textEditingController.text,
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
                  onPressed: () {
                    AppLoadingProgress.start(context);
                    submit(controller).then((value) {
                      AppLoadingProgress.stop(context);
                    });
                  },
                  icon: const Icon(Icons.send)),
            ),
            onChanged: (value) {
              // logger.d("onChanged $value");
              if (controller.isMessagesTooLong(controller.quoteMessages)) {
                showCustomToast(
                    title: "Too many quote messages".tr, context: context);
              }
              // controller.inputQuestion = value;
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
  QuoteMessagesComponent({super.key, required this.questionInputController});

  // ChatSessionController chatSessionController = Get.find();
  ChatMessageController chatMessageController = Get.find();
  QuestionInputController questionInputController;
  @override
  Widget build(BuildContext context) {
    if (questionInputController.questionInputModel.quotedMessages.isEmpty) {
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
          for (MessageModel message
              in questionInputController.questionInputModel.quotedMessages)
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
                // chatMessageController.removeQuoteMessage(message);
                questionInputController.removeQuotedMessage(message);
                // chatMessageController.update();
                questionInputController.update();
              },
            ),
        ],
      ),
    );
  }
}

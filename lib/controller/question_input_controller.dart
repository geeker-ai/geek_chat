import 'package:flutter/material.dart';
import 'package:geek_chat/models/geekerai/geekerai_models.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/question_input_model.dart';
import 'package:geek_chat/util/app_constants.dart';
import 'package:get/get.dart';

class QuestionInputController extends GetxController {
  TextEditingController textEditingController = TextEditingController();
  FocusNode inputFocus = FocusNode();

  QuestionInputModel questionInputModel = QuestionInputModel(
      inputText: '',
      imageParameterN: AppConstants.defaultDall3ImageN,
      imageParameterQuality: AppConstants.defaultDall3ImageQuality.id,
      imageParameterSize: AppConstants.defaultDall3ImageSize.id,
      imageParameterStyle: AppConstants.defaultDall3ImageStyle.id);

  String get inputText => questionInputModel.inputText;
  set inputText(String value) {
    textEditingController.text = value.trim();
    questionInputModel.inputText = textEditingController.text;
  }

  bool isQuotedMessagesTooLong() {
    return false;
  }

  void addQuotedMessage(MessageModel message) {
    if (!questionInputModel.quotedMessages.contains(message)) {
      questionInputModel.quotedMessages.add(message);
    }
  }

  void removeQuotedMessage(MessageModel message) {
    if (questionInputModel.quotedMessages.contains(message)) {
      questionInputModel.quotedMessages.remove(message);
    }
  }

  List<String> get imageSizeList {
    List<String> list = [];
    for (GeekerAIImageSize geekerAIImageSize in AppConstants.dalle3ImageSizes) {
      list.add(geekerAIImageSize.id);
    }
    return list;
  }

  String get defaultImageSize => AppConstants.defaultDall3ImageSize.id;

  List<String> get imageQualityList {
    List<String> list = [];
    for (GeekerAIImageQuality geekerAIImageQuality
        in AppConstants.dalle3ImageQualities) {
      list.add(geekerAIImageQuality.id);
    }
    return list;
  }

  String get defaultImageQuality => AppConstants.defaultDall3ImageQuality.id;

  List<String> get imageStyleList {
    List<String> list = [];
    for (GeekerAIImageStyle geekerAIImageStyle
        in AppConstants.dalle3ImageStyles) {
      list.add(geekerAIImageStyle.id);
    }
    return list;
  }

  String get defaultImageStyle => AppConstants.defaultDall3ImageStyle.id;

  List<String> get imageNList {
    List<String> list = [];
    for (int i in AppConstants.dalle3ImageN) {
      list.add(i.toString());
    }
    return list;
  }

  String get defaultImageN {
    return AppConstants.defaultDall3ImageN.toString();
  }
}

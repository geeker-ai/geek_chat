import 'package:flutter/material.dart';
import 'package:geek_chat/models/question_input_model.dart';
import 'package:geek_chat/util/app_constants.dart';
import 'package:get/get.dart';

class QuestionInputController extends GetxController {
  TextEditingController textEditingController = TextEditingController();
  FocusNode inputFocus = FocusNode();

  QuestionInputModel questionInputModel = QuestionInputModel(
      inputText: '',
      imageParameterN: AppConstants.defaultDall3ImageN,
      imageParameterQuality: AppConstants.defaultDall3ImageQuality,
      imageParameterSize: AppConstants.defaultDall3ImageSize,
      imageParameterStyle: AppConstants.defaultDall3ImageStyle);

  String get inputText => questionInputModel.inputText;
  set inputText(String value) {
    textEditingController.text = value.trim();
    questionInputModel.inputText = textEditingController.text;
  }

  List<String> get imageSizeList => AppConstants.dalle3ImageSizes;
  String get defaultImageSize => AppConstants.defaultDall3ImageSize;

  List<String> get imageQualityList => AppConstants.dalle3ImageQualities;
  String get defaultImageQuality => AppConstants.defaultDall3ImageQuality;

  List<String> get imageStyleList => AppConstants.dalle3ImageStyles;
  String get defaultImageStyle => AppConstants.defaultDall3ImageStyle;

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

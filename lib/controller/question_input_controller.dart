import 'package:flutter/material.dart';
import 'package:geek_chat/models/question_input_model.dart';
import 'package:geek_chat/util/app_constants.dart';
import 'package:get/get.dart';

class QuestionInputController extends GetxController {
  TextEditingController textEditingController = TextEditingController();
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
}

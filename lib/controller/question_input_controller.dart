import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:geek_chat/models/geekerai/geekerai_models.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/question_input_model.dart';
import 'package:geek_chat/models/session.dart';
import 'package:geek_chat/service/http_service.dart';
import 'package:geek_chat/util/app_constants.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class QuestionInputController extends GetxController {
  TextEditingController textEditingController = TextEditingController();
  FocusNode inputFocus = FocusNode();
  Logger logger = Get.find();
  Directory applicationDocumentsDirectory;
  QuestionInputController({required this.applicationDocumentsDirectory});

  String get uploadTmpDirectory {
    String path = "${applicationDocumentsDirectory.path}/upload";
    final check = Directory(path).existsSync();
    if (check == false) {
      Directory(path).create();
    }
    return path;
  }

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

  bool isQuotedMessagesTooLong(SessionModel currentSession) {
    int totalTokens = currentSession.maxContextSize -
        numTokenCounter(currentSession.model, inputText);
    totalTokens -=
        numTokenCounter(currentSession.model, currentSession.prompt.content);

    for (MessageModel message in questionInputModel.quotedMessages) {
      totalTokens -= numTokenCounter(currentSession.model, message.content);
    }
    if (totalTokens < 1) {
      return true;
    }
    return false;
  }

  void addQuotedMessage(MessageModel message) {
    logger.d("addQuotedMessage ${message.msgId}");
    if (!questionInputModel.quotedMessages.contains(message)) {
      questionInputModel.quotedMessages.add(message);
    }
  }

  void removeQuotedMessage(MessageModel message) {
    logger.d("removeQuotedMessage ${message.msgId}");
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

  void clear() {
    inputText = "";
    questionInputModel.quotedMessages.clear();
    questionInputModel.imageUrls.clear();
  }

  Future<dio.Response> uploadFile(
      {String? apiKey, required String uuid, required filePath}) async {
    Map<String, String> headers = {
      "uuid": uuid,
      if (apiKey != null) "Authorization": "Bearer $apiKey",
    };
    dio.FormData data = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(filePath),
    });
    return HttpClientService.postData("https://api2.fucklina.com/app/upload",
        data: data, headers: headers);
  }
}

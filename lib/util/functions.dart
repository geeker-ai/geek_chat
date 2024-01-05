import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_tiktoken/flutter_tiktoken.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:moment_dart/moment_dart.dart';

enum DeviceType { small, wide }

DeviceType getDeviceType() {
  String deviceTypeConfig = dotenv.get("DEVICE_TYPE");
  if (deviceTypeConfig == 'sm') {
    return DeviceType.small;
  } else if (deviceTypeConfig == 'wide') {
    return DeviceType.wide;
  }
  // return DeviceType.small;
  double ratio = PlatformDispatcher.instance.displays.first.devicePixelRatio;
  Size size = PlatformDispatcher.instance.displays.first.size;
  // print("ration $ratio , size: $size");
  double width = size.width / ratio;
  double height = size.height / ratio;
  Logger logger = Get.find<Logger>();
  // print("width: $width , height: $height");
  logger.d("screen size -> width: $width , height: $height");
  logger.d(
      "screen size -> width: ${size.width}, height: ${size.height}, ratio: $ratio");
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    return DeviceType.wide;
  }

  // Pixel fold
  if (size.width > 1500 && size.height > 2000) {
    return DeviceType.wide;
  }
  if (width > 1000.0 && height > 700.0) {
    return DeviceType.wide;
  }
  return DeviceType.small;
}

int numTokenCounter(String model, String content) {
  String modelStr = model;
  if (model == "chat-bison" ||
      model == "codechat-bison" ||
      model == "codechat-bison-32k" ||
      model == "chat-bison-32k" ||
      model == "gemini-pro" ||
      model == "gemini-pro-vision") {
    modelStr = "gpt-3.5-turbo";
  }
  final encoding = encodingForModel(modelStr);
  final numTokens = encoding.encode(content).length;
  return numTokens;
}

showCustomToast({required String title, required BuildContext context}) {
  showToast(title,
      context: context,
      position:
          const StyledToastPosition(align: Alignment.topRight, offset: 20.0),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      textStyle: TextStyle(color: Theme.of(context).colorScheme.background));
}

bool checkVersion(currentVersion, releaseVersion) {
  if (convertVersionToNumber(releaseVersion) >
      convertVersionToNumber(currentVersion)) {
    return true;
  }
  return false;
}

// bool checkUpdate(String remote)

int convertVersionToNumber(String version) {
  List versionCells = version.replaceFirst('v', '').split('.');
  versionCells = versionCells.map((i) => int.parse(i)).toList();
  return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
}

int getCurrentDateTime() {
  return int.parse(Moment.now().format('YYYYMMDDHHmmssSSS').toString());
}

int getCurrentDate() {
  return int.parse(Moment.now().format("YYYYMMDD".toString()));
}

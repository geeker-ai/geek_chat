import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_tiktoken/flutter_tiktoken.dart';
import 'package:geek_chat/service/http_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

enum DeviceType { small, wide }

DeviceType getDeviceType() {
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

  // TODO 折叠屏设备? iPad等设备
  if (width > 1000.0 && height > 700.0) {
    return DeviceType.wide;
  }
  return DeviceType.small;
}

int numTokenCounter(String model, String content) {
  final encoding = encodingForModel(model);
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

Future<bool> checkUpdate(String currentVersion) async {
  List<String> urls = [
    "https://pub-6be131b6553c4ce5a6f736f91a7d011a.r2.dev/latest.json",
    "https://gist.githubusercontent.com/zmhu/52a66708a59c6f7501c01bb43e3adcbd/raw/693d2e9b5935be027ef9f8cd5d38617259827695/latest.json"
  ];
  String version = '';
  for (String url in urls) {
    version = await HttpClientService.getVersion(url);
    if (version.isNotEmpty) {
      break;
    }
  }
  if (convertVersionToNumber(version) >
      convertVersionToNumber(currentVersion)) {
    return true;
  }
  return false;
}

int convertVersionToNumber(String version) {
  List versionCells = version.replaceFirst('v', '').split('.');
  versionCells = versionCells.map((i) => int.parse(i)).toList();
  return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
}

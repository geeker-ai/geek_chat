import 'dart:ui';

import 'package:flutter_tiktoken/flutter_tiktoken.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

enum DeviceType { small, wide }

DeviceType getDeviceType() {
  double ratio = PlatformDispatcher.instance.displays.first.devicePixelRatio;
  Size size = PlatformDispatcher.instance.displays.first.size;
  // print("ration $ratio , size: $size");
  double width = size.width;
  double height = size.height;
  Logger logger = Get.find<Logger>();
  // print("width: $width , height: $height");
  logger.d("screen size -> width: $width , height: $height");
  logger.d("screen size -> width: ${size.width}, height: ${size.height}, ratio: $ratio");
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

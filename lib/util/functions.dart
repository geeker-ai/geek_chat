import 'dart:ui';

import 'package:flutter_tiktoken/flutter_tiktoken.dart';

enum DeviceType { small, wide }

DeviceType getDeviceType() {
  double ratio = PlatformDispatcher.instance.displays.first.devicePixelRatio;
  Size size = PlatformDispatcher.instance.displays.first.size;
  // print("ration $ratio , size: $size");
  double width = size.width / ratio;
  double height = size.height / ratio;
  // print("width: $width , height: $height");
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

import 'dart:ui';

enum DeviceType { small, wide }

DeviceType getDeviceType() {
  double ratio = PlatformDispatcher.instance.displays.first.devicePixelRatio;
  Size size = PlatformDispatcher.instance.displays.first.size;
  // print("ration $ratio , size: $size");
  double width = size.width / ratio;
  double height = size.height / ratio;
  // print("width: $width , height: $height");
  if (width > 1000.0 && height > 800.0) {
    return DeviceType.wide;
  }
  return DeviceType.small;
}

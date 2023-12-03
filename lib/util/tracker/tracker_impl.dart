import 'package:geek_chat/util/tracker/tracker_interface.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class GeekChatTrackerImpl implements GeekChatTrackerInterface {
  Logger logger = Get.find();
  @override
  Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? props]) async {
    logger.d("event: $eventName, props: $props");
  }
}

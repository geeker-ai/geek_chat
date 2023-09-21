import 'dart:collection';

import 'package:get/get.dart';

class MessageBlockController extends GetxController {
  LinkedHashMap<String, bool> displays = LinkedHashMap<String, bool>();

  bool isDisplay(String msgId) {
    if (displays.containsKey(msgId)) {
      if (displays[msgId]!) {
        return true;
      }
    }
    return false;
  }

  setDisplay(String msgId, bool d) {
    displays[msgId] = d;
  }
}

import 'dart:collection';
import 'dart:ui';

import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/util/app_constants.dart';
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

  late Offset mousePosition;

  final Map<String, AiModel> _aiModels = {};

  AiModel getAiModelbyName(String modelName) {
    if (_aiModels.containsKey(modelName)) {
      return _aiModels[modelName]!;
    } else {
      AiModel aiModel = AppConstants.getAiModel(modelName);
      _aiModels[modelName] = aiModel;
      return aiModel;
    }
  }
}

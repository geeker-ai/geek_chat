import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/models/session.dart';
import 'package:geek_chat/util/app_constants.dart';
import 'package:get/get.dart';

class ChatSessionEditController extends GetxController {
  late SessionModel session;

  bool isEdit = false;

  SessionModel switchSessionModel(String modelName) {
    AiModel aiModel = AppConstants.getAiModel(modelName);
    session.model = aiModel.modelName;
    session.modelType = aiModel.modelType.name;
    session.maxContextMsgCount = aiModel.maxContextMsgCount ?? 22;
    session.maxContextSize = aiModel.maxContextSize;
    return session;
  }
}

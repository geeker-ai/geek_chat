import 'package:dart_openai/dart_openai.dart';
import 'package:geek_chat/controller/settings_server_controller.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/question_input_model.dart';
import 'package:geek_chat/models/server.dart';
import 'package:geek_chat/models/session.dart';

class GeekerAIUtils {
  static final GeekerAIUtils _geekerAIUtils = GeekerAIUtils._();

  static GeekerAIUtils get instance => _geekerAIUtils;

  ServerModel? defaultServer;

  OpenAI getOpenaiInstance(ServerModel defaultServer) {
    defaultServer = defaultServer;
    initOpenAI(defaultServer);
    return OpenAI.instance;
  }

  OpenAI getGeekerChatInstance(ServerModel defaultServer) {
    return getOpenaiInstance(defaultServer);
  }

  /// TODO
  List<MessageModel> getHistoryMessages(
      List<MessageModel> messages, SessionModel session) {
    List<MessageModel> historyMessages = [];
    return historyMessages;
  }

  /// TODO
  // OpenAIImageModel createImage(QuestionInputModel input) {
  //   OpenAIImageModel image = getOpenaiInstance(serverController)
  // }

  /// TODO

  GeekerAIUtils._();

  initOpenAI(ServerModel defaultServer) {
    OpenAI.apiKey = defaultServer.apiKey;
    OpenAI.baseUrl = defaultServer.apiHost;
    // OpenAI.showLogs = true;
    // OpenAI.showResponsesLogs = true;
  }
}

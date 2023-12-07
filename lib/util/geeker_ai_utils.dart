import 'package:dart_openai/dart_openai.dart';
import 'package:geek_chat/controller/settings_server_controller.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/session.dart';

class GeekerAIUtils {
  static final GeekerAIUtils _geekerAIUtils = GeekerAIUtils._();

  static GeekerAIUtils get instance => _geekerAIUtils;

  OpenAI getOpenaiInstance(SettingsServerController serverController) {
    initOpenAI(serverController);
    return OpenAI.instance;
  }

  OpenAI getGeekerChatInstance(SettingsServerController serverController) {
    return getOpenaiInstance(serverController);
  }

  /// TODO
  List<MessageModel> getHistorySessions(
      List<MessageModel> messages, SessionModel session) {
    List<MessageModel> historyMessages = [];
    return historyMessages;
  }

  /// TODO

  GeekerAIUtils._();

  initOpenAI(SettingsServerController serverController) {
    OpenAI.apiKey = serverController.defaultServer.apiKey;
    OpenAI.baseUrl = serverController.defaultServer.apiHost;
  }
}

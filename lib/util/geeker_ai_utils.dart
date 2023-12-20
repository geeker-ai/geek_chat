import 'package:dart_openai/dart_openai.dart';
// import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/server.dart';
import 'package:geek_chat/util/app_constants.dart';
// import 'package:geek_chat/models/session.dart';

class GeekerAIUtils {
  static final GeekerAIUtils _geekerAIUtils = GeekerAIUtils._();

  static GeekerAIUtils get instance => _geekerAIUtils;

  ServerModel? defaultServer;

  OpenAI getOpenaiInstance(ServerModel defaultServer) {
    defaultServer = defaultServer;
    OpenAI.apiKey = defaultServer.apiKey;
    OpenAI.baseUrl = defaultServer.apiHost;
    OpenAI.requestsTimeOut = const Duration(seconds: 60);
    OpenAI.showLogs = debug;
    OpenAI.showResponsesLogs = debug;
    return OpenAI.instance;
  }

  AzureOpenAI getAzureOpenaiInstance(ServerModel defaultServer, String model) {
    AzureOpenAI.apiKey = defaultServer.getApiKeyByModel(model);
    AzureOpenAI.baseUrl = defaultServer.getBaseUrlByModel(model);
    AzureOpenAI.apiVersion = AppConstants.azureAPIVersion;
    AzureOpenAI.requestsTimeOut = const Duration(seconds: 60);
    AzureOpenAI.showLogs = debug;
    AzureOpenAI.showResponsesLogs = debug;
    return AzureOpenAI.instance;
  }

  OpenAI getGeekerChatInstance(ServerModel defaultServer) {
    return getOpenaiInstance(defaultServer);
  }

  /// TODO
  // List<MessageModel> getHistoryMessages(
  //     List<MessageModel> messages, SessionModel session) {
  //   List<MessageModel> historyMessages = [];
  //   return historyMessages;
  // }

  /// TODO
  // OpenAIImageModel createImage(QuestionInputModel input) {
  //   OpenAIImageModel image = getOpenaiInstance(serverController)
  // }
  // https://openai-sweden-center.openai.azure.com/openai/deployments/dalle3/images/generations?api-version=2023-09-15-preview
  // https://openai-sweden-center.openai.azure.com/openai/deployments/dalle3/images/generations?api-version=2023-12-01-preview
  /// TODO

  GeekerAIUtils._();

  initOpenAI(ServerModel defaultServer, {String? model}) {
    if (defaultServer.provider == "azure") {
      AzureOpenAI.apiKey = defaultServer.getApiKeyByModel(model!);
      AzureOpenAI.baseUrl = defaultServer.getBaseUrlByModel(model);
      AzureOpenAI.requestsTimeOut = const Duration(seconds: 60);
      AzureOpenAI.showLogs = debug;
      AzureOpenAI.showResponsesLogs = debug;
      return AzureOpenAI.instance;
    } else {
      OpenAI.apiKey = defaultServer.apiKey;
      OpenAI.baseUrl = defaultServer.apiHost;
      OpenAI.requestsTimeOut = const Duration(seconds: 60);
      OpenAI.showLogs = debug;
      OpenAI.showResponsesLogs = debug;
      return OpenAI.instance;
    }
  }

  bool debug = true;
}

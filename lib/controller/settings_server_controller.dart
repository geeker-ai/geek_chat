import 'dart:convert';

import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/models/server.dart';
import 'package:geek_chat/repository/localstore_repository.dart';
import 'package:geek_chat/service/http_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class SettingsServerController extends GetxController {
  SettingsServerController({required this.provider}) {
    switchSettings(provider);
  }

  final LocalStoreRepository _localStoreRepository = Get.find();
  final Logger logger = Logger();

  void switchSettings(String provider) {
    this.provider = provider;
    defaultServer = _localStoreRepository.getServerSettings(provider);
    // editServer = _localStoreRepository.getServerSettings(provider);
    logger.d("switchSettings: ${defaultServer.toJson()}");
    errorMessage = '';
    activeError = false;
    needReactive = false;
  }

  // OpenAIClient get openAIClient {
  //   OpenAIClient openAIClient = OpenAIClient(
  //       apiKey: defaultServer.apiKey, baseUrl: defaultServer.apiHost);
  //   return openAIClient;
  // }

  // OpenAIClient get geekChatClient {
  //   return openAIClient;
  // }

  // OpenAIClient getAzureClient(AiModel model) {
  //   OpenAIClient openAIClient = OpenAIClient(
  //     baseUrl: defaultServer.getRequestURLByModel(model),
  //     headers: {'api-key': defaultServer.apiKey},
  //     queryParams: {'api-version': defaultServer.azureApiVersion},
  //   );
  //   return openAIClient;
  // }

  void saveSettings(ServerModel serverModel) {
    _localStoreRepository.saveSeverSettings(serverModel);
    switchSettings(serverModel.provider);
  }

  String provider;

  late ServerModel defaultServer;
  // late ServerModel editServer;

  bool get isPro {
    if (defaultServer.provider == 'geekerchat' &&
        defaultServer.isActived == true) {
      return true;
    } else {
      return false;
    }
  }

  /// geeker chat active UI controll
  String errorMessage = '';
  bool activeError = false;
  String inputLicense = '';
  bool needReactive = false;
  Future<ServerModel> activeLicense(
      String license, String uuid, String language) async {
    ServerModel serverModel = ServerModel(provider: provider, isActived: false);
    String rtnString = await HttpClientService.activeLicense(
        "https://capi.fucklina.com/activate", license, uuid, language);
    logger.d("rtn string: $rtnString");
    Map<String, dynamic> jsonObj = jsonDecode(rtnString);
    if (jsonObj.containsKey('actived')) {
      serverModel.isActived = jsonObj['actived'];
      serverModel.apiHost = jsonObj['baseUrl'];
      serverModel.apiKey = jsonObj['apiKey'];
      serverModel.license = license;
      serverModel.message = jsonObj['message'];
    } else {
      // serverModel.message = jsonObj['message'];
      errorMessage = jsonObj['message'];
      activeError = true;
      needReactive = true;
    }
    return serverModel;
  }
}

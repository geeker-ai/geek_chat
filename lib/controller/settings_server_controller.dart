import 'dart:convert';

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
  }

  void saveSettings(ServerModel serverModel) {
    _localStoreRepository.saveSeverSettings(serverModel);
    switchSettings(serverModel.provider);
  }

  String provider;

  late ServerModel defaultServer;
  // late ServerModel editServer;

  /// geeker chat active UI controll
  String inputLicense = '';
  bool needReactive = false;
  Future<ServerModel> activeLicense(
      String license, String uuid, String language) async {
    ServerModel serverModel = ServerModel(provider: provider, isActived: false);
    String rtnString = await HttpClientService.activeLicense(
        "https://capi.fucklina.com/activate", license, uuid, language);
    Map<String, dynamic> jsonObj = jsonDecode(rtnString);
    if (jsonObj.containsKey('actived')) {
      serverModel.isActived = jsonObj['actived'];
      serverModel.apiHost = jsonObj['baseUrl'];
      serverModel.apiKey = jsonObj['apiKey'];
      serverModel.license = license;
    } else {
      serverModel.message = jsonObj['message'];
      needReactive = true;
    }
    return serverModel;
  }
}

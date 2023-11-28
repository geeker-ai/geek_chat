import 'dart:convert';

import 'package:geek_chat/models/model.dart';

class ServerModel {
  String provider;
  String apiHost;
  String apiKey;
  String license;
  String deploymentId;
  bool isActived;
  String message = '';
  // bool error = false;
  Map<String, Map<String, String>> azureConfig = {};
  String azureApiVersion = "2023-05-15";

  ServerModel({
    required this.provider,
    this.apiHost = '',
    this.apiKey = '',
    this.license = '',
    this.deploymentId = '',
    this.isActived = false,
  }) {
    if (azureConfig.isEmpty) {
      azureConfig = {
        "gpt-3.5-turbo": {
          "name": "gpt-3.5-turbo",
          "deploymentId": "",
          "url": "",
        },
        "gpt-3.5-turbo-16k": {
          "name": "gpt-3.5-turbo-16k",
          "deploymentId": "",
          "url": ""
        },
        "gpt-4": {"name": "gpt-4", "deploymentId": "", "url": ""}
      };
    }
  }

  Map<String, String> getAzureModelSettings(String modelName) {
    return azureConfig[modelName]!;
  }

  String getRequestURL(String modelName) {
    if (provider == 'azure') {
      Map<String, String> modelSettings = getAzureModelSettings(modelName);
      String url = modelSettings['url']!;
      if (url.substring(url.length - 1) == '/') {
        url = url.substring(0, url.length - 1);
      }
      return "${modelSettings['url']}/openai/deployments/${modelSettings['deploymentId']}/chat/completions?api-version=$azureApiVersion";
    } else {
      return "$apiHost/v1/chat/completions";
    }
  }

  String getRequestURLByModel(AiModel model) {
    if (provider == 'azure') {
      Map<String, String> modelSettings =
          getAzureModelSettings(model.modelName);
      String url = modelSettings['url']!;
      if (url.substring(url.length - 1) == '/') {
        url = url.substring(0, url.length - 1);
      }
      return "${modelSettings['url']}/openai/deployments/${modelSettings['deploymentId']}/chat/completions?api-version=$azureApiVersion";
    } else {
      if (model.aiType == AiType.bard) {
        return "https://api2.fucklina.com/app/gbard";
      } else {
        return "$apiHost/v1/chat/completions";
      }
    }
  }

  Map<String, String> getRequestHeaders() {
    if (provider == 'azure') {
      return {
        'Accept': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'api-key': apiKey,
        'Content-Type': 'application/json',
        // 'Accept-Language': settingsController.lang
      };
    } else {
      return {
        'Accept': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        // 'Accept-Language': settingsController.lang
      };
    }
  }

  setModelSettins(String modelName, String deploymentId, String url) {
    azureConfig[modelName] = {
      "name": modelName,
      "deploymentId": deploymentId,
      "url": url
    };
  }

  factory ServerModel.fromJson(Map<String, dynamic> jsonObj) {
    ServerModel serverModel = ServerModel(
      provider: jsonObj['provider']!,
      apiHost: jsonObj['apiHost']!,
      apiKey: jsonObj['apiKey']!,
      license: jsonObj['license']!,
      deploymentId: jsonObj['deploymentId']!,
      isActived: jsonObj['isActived']!,
    );
    if (jsonObj.containsKey('azureApiVersion')) {
      serverModel.azureApiVersion = jsonObj['azureApiVersion'];
    }
    if (jsonObj.containsKey("azureConfig")) {
      var azconfig = jsonObj['azureConfig'];
      for (var key in azconfig.keys) {
        serverModel.azureConfig[key] = {
          "name": azconfig[key]!['name'],
          "deploymentId": azconfig[key]!['deploymentId'],
          "url": azconfig[key]!['url']
        };
      }
    }
    return serverModel;
  }

  factory ServerModel.fromJsonStr(String jsonStr) {
    Map<String, dynamic> jsonObj = jsonDecode(jsonStr);
    return ServerModel.fromJson(jsonObj);
  }

  Map<String, dynamic> toJson() => {
        "provider": provider,
        "apiHost": apiHost,
        "apiKey": apiKey,
        "license": license,
        "deploymentId": deploymentId,
        "isActived": isActived,
        "azureConfig": azureConfig,
        "azureApiVersion": azureApiVersion,
      };
}

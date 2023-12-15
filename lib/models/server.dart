import 'dart:convert';

import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/util/app_constants.dart';

class ProviderModel {
  ProviderModel(
      {required this.id,
      required this.name,
      required this.baseUrl,
      required this.supportedModels});
  String id;
  String name;
  String baseUrl;
  List<String> supportedModels;

  String get url {
    return baseUrl;
  }
}

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
          "apiKey": "",
          "deploymentId": "",
          "url": "",
          // "apiVersion": "",
        },
        "gpt-3.5-turbo-16k": {
          "name": "gpt-3.5-turbo-16k",
          "apiKey": "",
          "deploymentId": "",
          "url": "",
          // "apiVersion": "",
        },
        "gpt-4": {
          "name": "gpt-4",
          "apiKey": "",
          "deploymentId": "",
          "url": "",
          // "apiVersion": "",
        },
        "gpt-4-32k": {
          "name": "gpt-4-32k",
          "apiKey": "",
          "deploymentId": "",
          "url": "",
          // "apiVersion": "",
        }
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

  String getRequestUrlForOpenaiDart(String modelName) {
    if (provider == 'azure') {
      Map<String, String> modelSettings = getAzureModelSettings(modelName);
      String url = modelSettings['url']!;
      if (url.substring(url.length - 1) == '/') {
        url = url.substring(0, url.length - 1);
      }
      return "${modelSettings['url']}/openai/deployments/${modelSettings['deploymentId']}";
    } else {
      return "$apiHost/v1/chat/completions";
    }
  }

  String getApiKey(AiModel model) {
    if (provider == 'azure') {
      Map<String, String> modelSettings =
          getAzureModelSettings(model.modelName);
      if (modelSettings.containsKey("apiKey")) {
        return "${modelSettings['apiKey']}";
      }
    }
    return apiKey;
  }

  String getApiKeyByModel(String modelName) {
    if (provider == 'azure') {
      Map<String, String> modelSettings = getAzureModelSettings(modelName);
      if (modelSettings.containsKey("apiKey")) {
        return "${modelSettings['apiKey']}";
      }
    }
    return apiKey;
  }

  String getDeploymentIdByModel(String modelName) {
    //deploymentId
    Map<String, String> modelSettings = getAzureModelSettings(modelName);
    if (modelSettings.containsKey("deploymentId")) {
      return "${modelSettings['deploymentId']}";
    }
    return "No deploymentId";
  }

  String getBaseUrlByModel(String modelName) {
    if (provider == "azure") {
      Map<String, String> modelSettings = getAzureModelSettings(modelName);
      if (modelSettings.containsKey("url")) {
        return "${modelSettings['url']}";
      }
    }
    return apiHost;
  }

  String getApiVersion(String modelName) {
    if (provider == 'azure') {
      return AppConstants.azureAPIVersion;
      // Map<String, String> modelSettings = getAzureModelSettings(modelName);
      // if (modelSettings.containsKey('apiVersion')) {
      //   return "${modelSettings['apiVersion']}";
      // }
    }
    return AppConstants.azureAPIVersion;
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
      // apiHost = "https://api2.fucklina.com";
      if (model.aiType == AiType.bard) {
        return "$apiHost/app/gbard";
      } else {
        return "$apiHost/v1/chat/completions";
      }
    }
  }

  Map<String, String> getRequestHeaders(AiModel model) {
    if (provider == 'azure') {
      return {
        'Accept': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'api-key': getApiKey(model),
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
      "apiKey": apiKey,
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
      String apiKey = jsonObj['apiKey'];

      for (var key in azconfig.keys) {
        String tmpKey = "";
        // String tmpVersion = "";
        // print("--------------------------${azconfig[key].keys}");
        if (azconfig[key]!.containsKey("apiKey")) {
          tmpKey = azconfig[key]!['apiKey'];
        } else {
          tmpKey = apiKey;
        }
        // if (azconfig[key]!.containsKey("apiVersion")) {
        //   tmpVersion = azconfig[key]!['apiVersion'];
        // } else {
        //   tmpVersion = serverModel.azureApiVersion;
        // }
        serverModel.azureConfig[key] = {
          "name": azconfig[key]!['name'],
          "deploymentId": azconfig[key]!['deploymentId'],
          "apiKey": tmpKey,
          "url": azconfig[key]!['url'],
          // "apiVersion": tmpVersion
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

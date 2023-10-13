import 'dart:convert';

class ServerModel {
  String provider;
  String apiHost;
  String apiKey;
  String license;
  String deploymentId;
  bool isActived;
  String message = '';

  ServerModel({
    required this.provider,
    this.apiHost = '',
    this.apiKey = '',
    this.license = '',
    this.deploymentId = '',
    this.isActived = false,
  });

  factory ServerModel.fromJson(Map<String, dynamic> jsonObj) {
    return ServerModel(
      provider: jsonObj['provider']!,
      apiHost: jsonObj['apiHost']!,
      apiKey: jsonObj['apiKey']!,
      license: jsonObj['license']!,
      deploymentId: jsonObj['deploymentId']!,
      isActived: jsonObj['isActived']!,
    );
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
        "isActived": isActived
      };
}

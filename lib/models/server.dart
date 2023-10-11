class ServerModel {
  String provider;
  String apiHost;
  String apiKey;
  String license;
  String deploymentId;
  bool isActive;

  ServerModel({
    required this.provider,
    this.apiHost = '',
    this.apiKey = '',
    this.license = '',
    this.deploymentId = '',
    this.isActive = false,
  });
}

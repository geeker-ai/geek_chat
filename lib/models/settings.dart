class SettingsModel {
  String provider;
  String apiKey;
  String apiHost;
  bool showWordCount;
  bool showTokenCount;
  bool showModelName;
  String theme;
  String language;
  String fontSize;
  String license;
  bool isActived;
  bool autoSyncEnabled;
  late String uuid;

  SettingsModel({
    this.provider = '',
    this.apiKey = '',
    this.apiHost = '',
    this.showWordCount = false,
    this.showTokenCount = false,
    this.showModelName = true,
    this.theme = 'System',
    this.language = '',
    this.fontSize = '13',
    this.license = '',
    this.isActived = false,
    this.autoSyncEnabled = false,
    this.uuid = '',
  });

  set settingsJson(Map<String, dynamic> jsonObject) {
    provider = jsonObject["provider"];
    apiKey = jsonObject['apiKey'];
    apiHost = jsonObject['apiHost'];
    showWordCount = jsonObject['showWordCount'];
    showTokenCount = jsonObject['showTokenCount'];
    showModelName = jsonObject['showModelName'];
    theme = jsonObject['theme'];
    language = jsonObject['language'];
    fontSize = jsonObject['fontSize'];
    license = jsonObject['license'];
    isActived = jsonObject['isActived'];
    autoSyncEnabled = jsonObject['autoSyncEnabled'];
    if (jsonObject.containsKey('uuid')) {
      uuid = jsonObject['uuid'];
    } else {
      uuid = '';
    }
  }

  Map<String, dynamic> toJson() => {
        "provider": provider,
        "apiKey": apiKey,
        "apiHost": apiHost,
        "showWordCount": showWordCount,
        "showTokenCount": showTokenCount,
        "showModelName": showModelName,
        "theme": theme,
        "language": language,
        "fontSize": fontSize,
        "license": license,
        "isActived": isActived,
        "autoSyncEnabled": autoSyncEnabled,
        "uuid": uuid
      };
}

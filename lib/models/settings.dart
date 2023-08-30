// import 'dart:convert';
// import 'dart:convert';

import 'package:flutter/material.dart';

class SettingsModel {
  String provider;
  String apiKey;
  String apiHost;
  bool showWordCount;
  bool showTokenCount;
  bool showModelName;
  ThemeMode theme;
  String language;
  String fontSize;
  String license;
  bool isActived;
  bool autoSyncEnabled;

  SettingsModel(
      {this.provider = '',
      this.apiKey = '',
      this.apiHost = 'https://api.openai.com',
      this.showWordCount = false,
      this.showTokenCount = false,
      this.showModelName = true,
      this.theme = ThemeMode.system,
      this.language = 'en_US',
      this.fontSize = '13',
      this.license = '',
      this.isActived = false,
      this.autoSyncEnabled = false});

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
        "autoSyncEnabled": autoSyncEnabled
      };

  ThemeMode get getTheme => theme;
  set setTheme(ThemeMode theme) {
    this.theme = theme;
  }
}

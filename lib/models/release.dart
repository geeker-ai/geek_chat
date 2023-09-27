import 'dart:convert';

import 'package:geek_chat/util/functions.dart';

class ReleaseModel {
  bool needUpdate = false;
  String version = '0.0.1';
  String currentVersion = '0.0.1';
  String currentChangeLog = '';
  late Map<String, String> changeLogs;

  ReleaseModel();

  factory ReleaseModel.fromJson(String jsonString, String currentVersion) {
    ReleaseModel releaseModel = ReleaseModel();
    releaseModel.currentVersion = currentVersion;
    if (jsonString.isNotEmpty) {
      try {
        var jsonObject = jsonDecode(jsonString);
        releaseModel.needUpdate =
            checkVersion(currentVersion, jsonObject['version']);
        releaseModel.version = jsonObject['version'];
      } catch (e) {
        //
      }
    }
    return releaseModel;
  }
}

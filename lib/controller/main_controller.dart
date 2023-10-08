import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/prompts.dart';
import 'package:geek_chat/models/release.dart';
import 'package:geek_chat/repository/localstore_repository.dart';
import 'package:geek_chat/service/http_service.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ChangeLogModel {
  String version;
  String pubDate;
  String content;
  ChangeLogModel(this.version, this.pubDate, this.content);
}

class MainController extends GetxController {
  static MainController get to => Get.find();
  Logger logger = Get.find();
  final LocalStoreRepository _localStoreRepository = Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  int _navIndex = 0;

  final menus = [
    {"title": "Chat"},
    {"title": "Prompts"},
    {"title": "Settings"}
  ];

  int get navIndex {
    return _navIndex;
  }

  String getTitle() {
    return "${menus[_navIndex]['title']}";
  }

  set navIndex(int index) {
    _navIndex = index;
    update();
  }

  late ReleaseModel _releaseModel;
  ReleaseModel get releaseModel {
    return _releaseModel;
  }

  checkUpdate(String currentVersion, Function callback) {
    List<String> urls = [
      "https://pub-6be131b6553c4ce5a6f736f91a7d011a.r2.dev/latest.json",
      "https://gist.githubusercontent.com/zmhu/52a66708a59c6f7501c01bb43e3adcbd/raw/693d2e9b5935be027ef9f8cd5d38617259827695/latest.json"
    ];
    Future<String> version = fetchReleaseInfo(urls);
    version.then((value) {
      logger.d("message: $value");
      if (value.isNotEmpty) {
        _releaseModel = ReleaseModel.fromJson(value, currentVersion);
        logger.d("release model: ${_releaseModel.needUpdate}");
        if (releaseModel.needUpdate) {
          callback(_releaseModel);
        }
      } else {
        _releaseModel = ReleaseModel();
      }
    });
  }

  bool get needRefreshPrompts {
    bool needRefresh = false;
    if (prompts.isEmpty) {
      needRefresh = true;
      return needRefresh;
    }
    if (promptLang == SettingsController.to.lang) {
      needRefresh = false;
    } else {
      return false;
    }
    return needRefresh;
  }

  List<PromptModel> prompts = [];
  String promptLang = '';
  Future<List<PromptModel>> initPrompts() async {
    prompts.clear();
    // if (prompts.isNotEmpty) {
    //   return prompts;
    // }
    promptLang = SettingsController.to.lang;
    int datestr = getCurrentDate();
    String key = "$datestr-${SettingsController.to.lang}";
    logger.d("initPrompts: $key");
    String jsonStr = '';
    if (key == _localStoreRepository.getPromptsLastUpdate()) {
      jsonStr = _localStoreRepository.getPromptsJsonString();
      logger.d("get prompts from local store");
    } else {
      jsonStr = await _fetchPrompts();
      if (jsonStr.isNotEmpty) {
        _localStoreRepository.savePrompts(jsonStr);
        _localStoreRepository.updatePromptsLastUpdate(key);
      }
    }

    if (jsonStr.isNotEmpty) {
      var jsonObj = jsonDecode(jsonStr);
      for (var item in jsonObj) {
        prompts.add(PromptModel(
            id: "${item['id']}", name: item['name'], prompt: item['prompt']));
      }
    }
    return prompts;
    // logger.d(prompts);
  }

  Future<String> _fetchPrompts() async {
    String url = "http://capi.fucklina.com/app/prompt";
    Map<String, String> headers = {
      "lang": SettingsController.to.lang,
    };

    String responseString = await HttpClientService.getPrompts(url, headers);
    return responseString;
  }

  Future<String> fetchReleaseInfo(List<String> urls) async {
    String version = '';
    for (String url in urls) {
      version = await HttpClientService.getReleaseInfo(url);
      if (version.isNotEmpty) {
        break;
      }
    }
    logger.d("remote get version: $version");
    return version;
  }

  loadChangeLog() async {
    List<String> urls = [
      'https://pub-6be131b6553c4ce5a6f736f91a7d011a.r2.dev/changelog.json',
      'https://gist.githubusercontent.com/zmhu/52a66708a59c6f7501c01bb43e3adcbd/raw/2dfcd417f024629e74c9b0d295be860fbc3ba188/changelog.json'
    ];
    Future<String> response = fetchReleaseInfo(urls);
    response.then((value) {
      versions.clear();
      var data = jsonDecode(value);
      for (var version in data['versions']) {
        versions.add(ChangeLogModel(
            version['version'], version['publish_at'], version['content']));
      }
      if (versions.isEmpty) {
        loadChangeLogDefault();
      }
    });
  }

  List<ChangeLogModel> versions = [];
  loadChangeLogDefault() async {
    versions.clear();
    var data = await rootBundle.loadString("assets/changelog.json");
    var vs = jsonDecode(data);
    for (var version in vs) {
      versions.add(ChangeLogModel(
          version['version'], version['pub_date'], version['content']));
    }
  }
}

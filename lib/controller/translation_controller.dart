import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:geek_chat/models/locale_model.dart';
import 'package:geek_chat/util/app_constants.dart';
import 'package:get/get.dart';

class TranslationController extends GetxController {
  final Map<String, Map<String, String>> keys = {};
  initTranslations() async {
    for (LocaleModel lang in AppConstants.locales) {
      String transFile = "assets/locales/${lang.locale}.json";
      String json = await rootBundle.loadString(transFile);
      keys[lang.languageCode] = Map.castFrom(jsonDecode(json));
    }
  }
}

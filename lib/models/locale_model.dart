import 'dart:convert';
import 'dart:ui';

class LocaleModel {
  LocaleModel({
    required this.imageIcon,
    required this.languageName,
    required this.languageCode,
    required this.countryCode,
    this.scriptCode,
    required this.languageStr,
  });

  String imageIcon;
  String languageName;
  String languageCode;
  String countryCode;
  String? scriptCode;

  /// 老系统中的Language Code
  String languageStr;

  String get id {
    return locale.toString();
  }

  Locale get locale {
    return Locale.fromSubtags(
        languageCode: languageCode,
        scriptCode: scriptCode,
        countryCode: countryCode);
  }

  String get promptLang {
    if (languageCode == "zh") {
      return "zh-Hans";
    } else {
      return languageCode;
    }
  }

  String toJson() {
    return jsonEncode({
      "id": id,
      "languageName": languageName,
      "languageCode": languageCode,
      "countryCode": countryCode,
      "scriptCode": scriptCode,
      "languageStr": languageStr,
    });
  }
}

import 'package:geek_chat/models/locale_model.dart';

class AppConstants {
  static LocaleModel defaultLocale = locales[0];

  // https://emojipedia.org/flags/
  static List<LocaleModel> locales = [
    LocaleModel(
      imageIcon: "🇺🇸",
      languageName: "English",
      languageCode: "en",
      countryCode: "US",
      // scriptCode: "",
      languageStr: "en_US",
    ),
    LocaleModel(
      imageIcon: "🇨🇳",
      languageName: "Simplified Chinese",
      languageCode: "zh",
      countryCode: "CN",
      scriptCode: "Hans",
      languageStr: "zh_Hans_CN",
    ),
    LocaleModel(
      imageIcon: "🇭🇰",
      languageName: "Traditional Chinese",
      languageCode: "zh",
      countryCode: "HK",
      scriptCode: "Hant",
      languageStr: "zh_Hant_HK",
    ),
    LocaleModel(
      imageIcon: "🇷🇺",
      languageName: "Russian",
      languageCode: "ru",
      countryCode: "RU",
      // scriptCode: "Hant",
      languageStr: "ru_RU",
    ),
    LocaleModel(
      imageIcon: "🇯🇵",
      languageName: "Japanese",
      languageCode: "ja",
      countryCode: "JP",
      // scriptCode: "Hant",
      languageStr: "ja_JP",
    )
  ];
}

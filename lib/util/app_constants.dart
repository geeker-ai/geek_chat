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
    )
  ];
}

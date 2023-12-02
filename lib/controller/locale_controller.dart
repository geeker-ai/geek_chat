import 'dart:ui';

import 'package:geek_chat/models/locale_model.dart';
import 'package:geek_chat/repository/localstore_repository.dart';
import 'package:geek_chat/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class LocaleController extends GetxController {
  /// 支持到老的 settings
  String lang = "";

  static String localeKey = "locale";

  LocaleModel locale = AppConstants.defaultLocale;
  LocalStoreRepository localStoreRepository = Get.find();
  Logger logger = Get.find();

  final List<LocaleModel> locales = AppConstants.locales;

  LocaleModel? getLocaleByString(String lang) {
    LocaleModel? localeModel;
    for (LocaleModel lm in locales) {
      if (lang == lm.languageStr) {
        localeModel = lm;
        break;
      }
    }
    return localeModel;
  }

  LocaleModel? getLocale(String localeId) {
    LocaleModel? localeModel;
    for (LocaleModel lm in AppConstants.locales) {
      logger.d("getLocale: localeId = $localeId, ${lm.id}");
      if (localeId == lm.id) {
        localeModel = lm;
        break;
      }
    }
    return localeModel;
  }

  detectiveLocale() {
    Locale? deviceLocale = Get.deviceLocale;
    LocaleModel? tmp;
    String? localeId = localStoreRepository.read<String>(localeKey);
    logger.d("get locale from db: $localeId");
    logger.d("get device locale: $deviceLocale ");
    logger.d(
        "divce locale countryCode: ${deviceLocale?.toString()}, ${deviceLocale?.countryCode}, languageCode: ${deviceLocale?.languageCode}, scriptCode: ${deviceLocale?.scriptCode}");
    if (localeId != null && localeId.isNotEmpty) {
      tmp = getLocale(localeId);
      logger.d("get locale from db: $tmp");
      if (tmp != null) {
        locale = tmp;
      }
    } else {
      // 如果有老的设置语言
      if (lang.isNotEmpty) {
        tmp = getLocaleByString(lang);
        logger.d("default lang: ${tmp?.toJson()} , lang: $lang");
      } else {
        /// 如果取到系统的语言则使用系统语言
        if (deviceLocale != null) {
          logger.d("get locale from system $deviceLocale");
          tmp = getLocale(deviceLocale.toString());
          logger.d("device locale: $tmp");
          if (tmp == null) {
            for (LocaleModel lm in AppConstants.locales) {
              if (lm.languageCode == deviceLocale.languageCode) {
                tmp = lm;
              } else if (lm.countryCode == deviceLocale.countryCode) {
                tmp = lm;
              }
            }
          }
        }
      }
    }
    if (tmp != null) {
      locale = tmp;
      logger.d("locale: ${locale.toJson()}");
      lang = tmp.languageStr;
      // saveLocale(locale.id);
    }
  }

  saveLocale(String localeId) {
    localStoreRepository.write(localeKey, localeId);
  }

  setLocale(String localeId) {
    LocaleModel? localeModel = getLocale(localeId);
    localeModel ??= AppConstants.defaultLocale;
    locale = localeModel;
    saveLocale(localeId);
    Get.updateLocale(Locale(localeModel.languageCode, localeModel.countryCode));
  }
}

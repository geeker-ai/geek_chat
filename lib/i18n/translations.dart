import 'package:geek_chat/controller/translation_controller.dart';
import 'package:get/get.dart';

class GeekChatTranslations extends Translations {
  TranslationController translationController = Get.find();
  @override
  Map<String, Map<String, String>> get keys {
    return translationController.keys;
  }
}

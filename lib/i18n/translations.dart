import 'package:get/get.dart';

class GeekChatTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          "appTitle": "GeekerChat",
          "Chat": "Chat",
          "Prompts": "Prompts",
          "Settings": "Settings",
          "toSecondPage": "to second page",
          "secondPage": "this is the second Page",
        },
        'zh_CN': {
          "appTitle": "GeekerChat",
          "Chat": "对话",
          "Prompts": "提示词",
          "Settings": "设置",
          "toSecondPage": "去到第二页",
          "secondPage": "这里上第二页",
        }
      };
}

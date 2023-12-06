import 'package:flutter/material.dart';
import 'package:geek_chat/models/locale_model.dart';
import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/models/theme.dart';

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

  /// AI 分类
  static List<AiGroup> aiGroups = [
    AiGroup(
        aitype: AiType.chatgpt,
        groupName: "ChatGPT",
        groupDesc: "OpenAI ChatGPT"),
    AiGroup(
        aitype: AiType.bard,
        groupName: "Google Vertex AI",
        groupDesc: "Google Vertex AI")
  ];

  /// AI 支持的模型
  static List<AiModel> aiModels = [
    AiModel(
        modelName: 'gpt-3.5-turbo',
        alias: 'gpt-3.5',
        aiType: AiType.chatgpt,
        modelType: ModelType.chat,
        temperature: 0.7,
        maxContextSize: 4000,
        modelMaxContextSize: 4000,
        maxTokens: 0),
    AiModel(
        modelName: 'gpt-3.5-turbo-16k',
        alias: 'gpt-3.5-16k',
        aiType: AiType.chatgpt,
        modelType: ModelType.chat,
        temperature: 0.7,
        maxContextSize: 10000,
        modelMaxContextSize: 16000,
        maxTokens: 0),
    AiModel(
        modelName: 'gpt-4',
        alias: 'gpt-4',
        aiType: AiType.chatgpt,
        modelType: ModelType.chat,
        temperature: 0.7,
        maxContextSize: 4000,
        modelMaxContextSize: 4000,
        maxTokens: 0),
    AiModel(
        modelName: 'gpt-4-32k',
        alias: 'gpt-4-32k',
        aiType: AiType.chatgpt,
        modelType: ModelType.chat,
        temperature: 0.7,
        maxContextSize: 15000,
        modelMaxContextSize: 15000,
        maxTokens: 0),
    AiModel(
        modelName: 'chat-bison',
        alias: 'chat-bison',
        aiType: AiType.bard,
        modelType: ModelType.chat,
        temperature: 0.7,
        maxContextSize: 7000,
        modelMaxContextSize: 8192,
        maxTokens: 0),
    AiModel(
        modelName: 'codechat-bison',
        alias: 'codechat-bison',
        aiType: AiType.bard,
        modelType: ModelType.chat,
        temperature: 0.7,
        maxContextSize: 5000,
        modelMaxContextSize: 6144,
        maxTokens: 0),
    AiModel(
        modelName: 'dall-e-3',
        alias: 'dall-e-3',
        aiType: AiType.chatgpt,
        modelType: ModelType.image,
        temperature: 1,
        maxContextSize: 0,
        modelMaxContextSize: 0,
        maxTokens: 0),
  ];

  static AiModel getAiModel(String modelName) {
    for (AiModel model in AppConstants.aiModels) {
      if (modelName == model.modelName) {
        return model;
      }
    }
    return AppConstants.aiModels[0];
  }

  //// Server List
  static List<Map<String, String>> serverList = [
    {
      'id': 'openai',
      'name': 'OpenAI',
      'url': 'https://api.openai.com',
    },
    {
      'id': 'geekerchat',
      'name': 'Geeker Chat',
      'url': 'https://capi.fucklina.com',
    },
    {
      'id': 'azure',
      'name': 'Azure API',
      'url': 'https://geek.azure.com',
    }
  ];

  static List<GCThemeMode> themeModes = [
    GCThemeMode(name: 'System', themeMode: ThemeMode.system),
    GCThemeMode(name: 'Dark', themeMode: ThemeMode.dark),
    GCThemeMode(name: 'Light', themeMode: ThemeMode.light),
  ];
}

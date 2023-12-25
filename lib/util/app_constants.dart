import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geek_chat/models/geekerai/geekerai_models.dart';
import 'package:geek_chat/models/locale_model.dart';
import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/models/server.dart';
import 'package:geek_chat/models/theme.dart';

enum ImageModelType { create, edit, variation }

class AppConstants {
  static LocaleModel defaultLocale = locales[0];

  /// https://github.com/Azure/azure-rest-api-specs/tree/main/specification/cognitiveservices/data-plane/AzureOpenAI/inference
  static String azureAPIVersion = "2023-12-01-preview";

  static String get appServerHost {
    String host = "https://capi.fucklina.com";
    if (kDebugMode) {
      host = "https://api2.fucklina.com";
    }
    return host;
  }

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
        aitype: AiType.google,
        groupName: "Google Gemini",
        groupDesc: "Google Gemini AI"),
    AiGroup(
        aitype: AiType.bard,
        groupName: "Google Vertex AI",
        groupDesc: "Google Vertex AI"),
  ];

  /// AI 支持的模型
  static List<AiModel> aiModels = [
    AiModel(
      modelName: 'gpt-3.5-turbo',
      alias: ['gpt-3.5'],
      aiType: AiType.chatgpt,
      modelType: ModelType.chat,
      temperature: 0.7,
      maxContextSize: 4000,
      modelMaxContextSize: 4000,
      // maxTokens: 4096,
    ),
    AiModel(
      modelName: 'gpt-3.5-turbo-16k',
      alias: ['gpt-3.5-16k'],
      aiType: AiType.chatgpt,
      modelType: ModelType.chat,
      temperature: 0.7,
      maxContextSize: 10000,
      modelMaxContextSize: 16000,
      // maxTokens: 6000,
    ),
    AiModel(
      modelName: 'gpt-4',
      alias: ['gpt-4'],
      aiType: AiType.chatgpt,
      modelType: ModelType.chat,
      temperature: 0.7,
      maxContextSize: 4000,
      modelMaxContextSize: 4000,
      // maxTokens: 1000000,
    ),
    AiModel(
      modelName: 'gpt-4-32k',
      alias: ['gpt-4-32k'],
      aiType: AiType.chatgpt,
      modelType: ModelType.chat,
      temperature: 0.7,
      maxContextSize: 15000,
      modelMaxContextSize: 15000,
      // maxTokens: 15000,
    ),
    AiModel(
        modelName: 'gpt-4-vision-preview',
        alias: ['gpt-4-vision-preview', 'gpt-4-vision'],
        aiType: AiType.chatgpt,
        modelType: ModelType.chat,
        temperature: 0.7,
        maxContextSize: 15000,
        modelMaxContextSize: 15000,
        maxTokens: 4096,
        enableImage: true,
        maxContextMsgCount: 8),
    AiModel(
      modelName: 'chat-bison',
      alias: ['chat-bison'],
      aiType: AiType.bard,
      modelType: ModelType.chat,
      temperature: 0.7,
      maxContextSize: 7000,
      modelMaxContextSize: 8192,
      // maxTokens: 8192,
    ),
    AiModel(
      modelName: 'codechat-bison',
      alias: ['codechat-bison'],
      aiType: AiType.bard,
      modelType: ModelType.chat,
      temperature: 0.7,
      maxContextSize: 5000,
      modelMaxContextSize: 6144,
      // maxTokens: 8192,
    ),
    AiModel(
      modelName: 'chat-bison-32k',
      alias: ['chat-bison-32k'],
      aiType: AiType.bard,
      modelType: ModelType.chat,
      temperature: 0.7,
      maxContextSize: 15000,
      modelMaxContextSize: 15000,
      // maxTokens: 32000,
    ),
    AiModel(
      modelName: 'codechat-bison-32k',
      alias: ['codechat-bison-32k'],
      aiType: AiType.bard,
      modelType: ModelType.chat,
      temperature: 0.7,
      maxContextSize: 15000,
      modelMaxContextSize: 15000,
      // maxTokens: 32000,
    ),
    AiModel(
      modelName: 'dall-e-3',
      alias: ['dall-e-3'],
      aiType: AiType.chatgpt,
      modelType: ModelType.image,
      temperature: 1,
      maxContextSize: 0,
      modelMaxContextSize: 0,
      // maxTokens: 0,
    ),
    AiModel(
      modelName: 'gemini-pro',
      alias: ['gemini-pro'],
      aiType: AiType.google,
      modelType: ModelType.chat,
      temperature: 0.7,
      maxContextSize: 2048,
      modelMaxContextSize: 2048,
      disablePrompt: true,
      // maxTokens: 0,
    ),
  ];

  static AiModel getAiModel(String modelName) {
    for (AiModel model in AppConstants.aiModels) {
      if (modelName == model.modelName) {
        return model;
      } else if (model.alias.contains(modelName)) {
        return model;
      }
    }
    return AppConstants.aiModels[0];
  }

  static List<String> get geminiModeNamelList {
    List<String> list = [];
    for (AiModel model in aiModels) {
      if (model.aiType == AiType.google) {
        list.add(model.modelName);
      }
    }
    return list;
  }

  static List<String> get allModelNameList {
    List<String> list = [];
    for (AiModel model in aiModels) {
      list.add(model.modelName);
    }
    return list;
  }

  static List<String> get geekerchatModelNameList {
    List<String> list = [];
    list.addAll(openaiModelNameList);
    list.addAll(vertexModelNameList);
    list.addAll(geminiModeNamelList);
    return list;
  }

  static List<String> get openaiModelNameList {
    List<String> list = [];
    for (AiModel model in aiModels) {
      if (model.aiType == AiType.chatgpt) {
        list.add(model.modelName);
      }
    }
    return list;
  }

  static List<String> get azureModelNameList {
    List<String> list = [];
    for (AiModel model in aiModels) {
      if (model.aiType == AiType.chatgpt) {
        list.add(model.modelName);
      }
    }
    return list;
  }

  static List<String> get vertexModelNameList {
    List<String> list = [];
    for (AiModel model in aiModels) {
      if (model.aiType == AiType.bard) {
        list.add(model.modelName);
      }
    }
    return list;
  }

  static List<ProviderModel> servers = [
    ProviderModel(
      id: "openai",
      name: "OpenAI",
      baseUrl: "https://api.openai.com",
      supportedModels: openaiModelNameList,
    ),
    ProviderModel(
      id: "geekerchat",
      name: "Geeker Chat",
      baseUrl: "https://capi.fucklina.com",
      supportedModels: geekerchatModelNameList,
    ),
    ProviderModel(
      id: "azure",
      name: "Azure API",
      baseUrl: "",
      supportedModels: openaiModelNameList,
    ),
    ProviderModel(
        id: "gemini",
        name: "Google Gemini",
        baseUrl: "https://generativelanguage.googleapis.com",
        supportedModels: geminiModeNamelList),
  ];
  static ProviderModel getProvider(String providerId) {
    for (ProviderModel provider in servers) {
      if (provider.id == providerId) {
        return provider;
      }
    }
    return servers[0];
  }

  static List<GCThemeMode> themeModes = [
    GCThemeMode(name: 'System', themeMode: ThemeMode.system),
    GCThemeMode(name: 'Dark', themeMode: ThemeMode.dark),
    GCThemeMode(name: 'Light', themeMode: ThemeMode.light),
  ];

  // static List<String> dalle3ImageSizes = [
  //   '1024x1024',
  //   '1792x1024',
  //   '1024x1792'
  // ];
  static List<GeekerAIImageSize> dalle3ImageSizes = [
    GeekerAIImageSize(
        id: '1024x1024',
        name: '1024x1024',
        openAIImageSize: OpenAIImageSize.size1024),
    GeekerAIImageSize(
        id: '1792x1024',
        name: '1792x1024',
        openAIImageSize: OpenAIImageSize.size1792Horizontal),
    GeekerAIImageSize(
        id: '1024x1792',
        name: '1024x1792',
        openAIImageSize: OpenAIImageSize.size1792Vertical),
  ];
  static GeekerAIImageSize getGeekerAIImageSize(String sizeId) {
    for (GeekerAIImageSize size in dalle3ImageSizes) {
      if (size.id == sizeId) {
        return size;
      }
    }
    return defaultDall3ImageSize;
  }

  static GeekerAIImageSize defaultDall3ImageSize = dalle3ImageSizes[0];

  static List<GeekerAIImageQuality> dalle3ImageQualities = [
    GeekerAIImageQuality(id: 'standard', name: 'standard'),
    GeekerAIImageQuality(
        id: 'hd', name: 'hd', openAIImageQuality: OpenAIImageQuality.hd),
  ];
  static GeekerAIImageQuality defaultDall3ImageQuality =
      dalle3ImageQualities[0];
  static GeekerAIImageQuality getGeekerAIImageQuality(String qualityId) {
    for (GeekerAIImageQuality quality in dalle3ImageQualities) {
      if (quality.id == qualityId) {
        return quality;
      }
    }
    return defaultDall3ImageQuality;
  }

  static List<GeekerAIImageStyle> dalle3ImageStyles = [
    GeekerAIImageStyle(
        id: 'natural',
        name: 'natural',
        openAIImageStyle: OpenAIImageStyle.natural),
    GeekerAIImageStyle(
        id: 'vivid', name: 'vivid', openAIImageStyle: OpenAIImageStyle.vivid),
  ];
  static GeekerAIImageStyle getGeekerAIImageStyle(String styleId) {
    for (GeekerAIImageStyle style in dalle3ImageStyles) {
      if (style.id == styleId) {
        return style;
      }
    }
    return defaultDall3ImageStyle;
  }

  static GeekerAIImageStyle defaultDall3ImageStyle = dalle3ImageStyles[0];

  static List<int> dalle3ImageN = [1, 2, 4];
  static int defaultDall3ImageN = dalle3ImageN[0];
}

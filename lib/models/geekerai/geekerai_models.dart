import 'package:dart_openai/dart_openai.dart';

class GeekerAIImageSize {
  String id;
  String name;
  OpenAIImageSize openAIImageSize;
  GeekerAIImageSize({
    required this.id,
    required this.name,
    required this.openAIImageSize,
  });
}

class GeekerAIImageQuality {
  String id;
  String name;
  OpenAIImageQuality? openAIImageQuality;
  GeekerAIImageQuality({
    required this.id,
    required this.name,
    this.openAIImageQuality,
  });
}

class GeekerAIImageStyle {
  String id;
  String name;
  OpenAIImageStyle openAIImageStyle;
  GeekerAIImageStyle({
    required this.id,
    required this.name,
    required this.openAIImageStyle,
  });
}

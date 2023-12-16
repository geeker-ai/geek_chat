enum AiType {
  chatgpt,
  bard,
}

enum ModelType { chat, text, image }

class AiGroup {
  AiGroup({
    required this.aitype,
    required this.groupName,
    required this.groupDesc,
  });
  String groupName;
  AiType aitype;
  String groupDesc;
}

class AiModel {
  String modelName;
  String alias;
  AiType aiType;
  ModelType modelType;
  double temperature;
  int maxContextSize;
  int modelMaxContextSize;
  int maxTokens;
  bool? enableImage;

  AiModel({
    required this.modelName,
    required this.alias,
    required this.aiType,
    required this.modelType,
    required this.temperature,
    required this.maxContextSize,
    required this.modelMaxContextSize,
    required this.maxTokens,
    this.enableImage,
  });
}

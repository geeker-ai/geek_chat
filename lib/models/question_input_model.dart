class QuestionInputModel {
  QuestionInputModel({
    required this.inputText,
    this.imageParameterN,
    this.imageParameterQuality,
    this.imageParameterSize,
    this.imageParameterStyle,
  });

  int? imageParameterN;
  String? imageParameterQuality;
  String? imageParameterSize;
  String? imageParameterStyle;
  String inputText;
}

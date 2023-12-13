import 'package:geek_chat/models/message.dart';

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
  List<MessageModel> quotedMessages = [];

  String toJson() {
    return '{"inputText": "$inputText", "imageParameterN": $imageParameterN, "imageParameterQuality": "$imageParameterQuality", "imageParameterSize": "$imageParameterSize", "imageParameterStyle": "$imageParameterStyle"}';
  }
}

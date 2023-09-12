import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/message.dart';

// ignore: must_be_immutable
class MessageBlock extends StatelessWidget {
  MessageModel message;
  MessageBlock({super.key, required this.message});

  MainAxisAlignment getMainAxisAligment() {
    if (message.role == SettingsController.to.chatGPTRoles.assistant) {
      return MainAxisAlignment.start;
    } else {
      return MainAxisAlignment.end;
    }
  }

  BorderRadiusGeometry getBorderRadius() {
    double radius = 14;
    if (message.role == SettingsController.to.chatGPTRoles.assistant) {
      return BorderRadius.only(
        topRight: Radius.circular(radius),
        topLeft: Radius.circular(radius),
        // bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );
    } else {
      return BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
        // bottomRight: Radius.circular(radius),
      );
    }
  }

  final messageGap = 10.0;
  double getMessageLeftSizedBoxWidth() {
    if (message.role == SettingsController.to.chatGPTRoles.user) {
      return messageGap;
    }
    return 0;
  }

  double getMessageRightSizedBoxWidth() {
    if (message.role == SettingsController.to.chatGPTRoles.user) {
      return 0;
    }
    return messageGap;
  }

  Color getMessageBackgroundColor(BuildContext context) {
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    if (isDark) {
      return Colors.black54;
    } else {
      return Colors.black12;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: getMainAxisAligment(),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: getMessageLeftSizedBoxWidth(),
          ),
          Expanded(
            child: Container(
              // height: MediaQuery.of(context).size.height,
              // height: 400,
              padding: const EdgeInsets.only(
                  right: 10, left: 10, top: 10, bottom: 0),
              decoration: BoxDecoration(
                color: getMessageBackgroundColor(context),
                borderRadius: getBorderRadius(),
              ),
              // child: Text(
              //   message.content,
              //   softWrap: true,
              //   textDirection: TextDirection.ltr,
              // ),
              child: Markdown(
                data: message.content,
                selectable: true,
                shrinkWrap: true,
                // extensionSet: md.ExtensionSet(
                //   md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                //   <md.InlineSyntax>[
                //     md.EmojiSyntax(),
                //     ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
                //   ],
                // ),
              ),
            ),
          ),
          SizedBox(
            width: getMessageRightSizedBoxWidth(),
          ),
        ],
      ),
    );
  }
}

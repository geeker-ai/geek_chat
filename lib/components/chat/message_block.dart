import 'package:flutter/material.dart';
import 'package:geek_chat/components/markdown/latex.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/message.dart';
import 'package:markdown_widget/markdown_widget.dart';

// ignore: must_be_immutable
class MessageContent extends StatelessWidget {
  MessageModel message;
  MessageContent({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.role == 'user') {
      return userMessageBubble(context);
    } else {
      return assistentMessageBubble(context);
    }
  }

  Widget userMessageBubble(BuildContext context) {
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.only(right: 5, left: 5, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: getMessageBackgroundColor(context),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(radius),
                  topLeft: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                  // bottomRight: Radius.circular(radius),
                ),
              ),
              // constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
              child: markDownWidgetWithStream(message, isDark),
            ),
          )
        ],
      ),
    );
  }

  Color getMessageBackgroundColor(BuildContext context) {
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    if (isDark) {
      return Colors.grey[900]!;
    } else {
      return Colors.black12;
    }
  }

  double radius = 10;

  Widget assistentMessageBubble(BuildContext context) {
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              // width: double.infinity,
              padding:
                  const EdgeInsets.only(right: 5, left: 5, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: getMessageBackgroundColor(context),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(radius),
                  topLeft: Radius.circular(radius),
                  // bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                ),
              ),
              // constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
              child: markDownWidgetWithStream(message, isDark),
            ),
          ),
          // const Expanded(child: Text('')),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}

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
    double radius = 10;
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

  final messageGap = 15.0;
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
      return Colors.grey[900]!;
    } else {
      return Colors.black12;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: getMainAxisAligment(),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: getMessageLeftSizedBoxWidth(),
          ),
          Expanded(
            child: Container(
              // width: double.infinity,
              padding:
                  const EdgeInsets.only(right: 5, left: 5, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: getMessageBackgroundColor(context),
                borderRadius: getBorderRadius(),
              ),
              // constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
              child: markDownWidgetWithStream(message, isDark),
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

Widget markDownWidgetWithStream(MessageModel message, bool isDark) {
  if (message.generating == false) {
    return markDownWidget(message.content, isDark);
  } else {
    return StreamBuilder<String>(
        stream: message.contentStream!.stream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          String text = snapshot.data ?? '';
          if (message.generating == true) {
            text = "$text ...";
          }
          return markDownWidget(text, isDark);
        });
  }
}

Widget markDownWidget(String message, bool isDark) {
  Widget markdownWidget = MarkdownWidget(
    data: message,
    shrinkWrap: true,
    config: isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig,
    physics: const ScrollPhysics(),
    markdownGeneratorConfig: MarkdownGeneratorConfig(
      generators: [latexGenerator],
      inlineSyntaxList: [LatexSyntax()],
    ),
  );
  return markdownWidget;
}

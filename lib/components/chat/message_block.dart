import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geek_chat/components/markdown/latex.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:markdown_widget/markdown_widget.dart';

// ignore: must_be_immutable
class MessageContent extends StatelessWidget {
  MessageModel message;
  MessageContent({super.key, required this.message});

  Widget getMessageAvatar(BuildContext context) {
    if (message.role == 'user') {
      return const Icon(
        Icons.person_outline_outlined,
        size: 35,
      );
    }
    return SvgPicture.asset(
      'assets/chatgpt-grey.svg',
      width: 35,
      height: 35,
      // color: Theme.of(context).colorScheme.onBackground,
      colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.onBackground,
        BlendMode.srcIn,
      ),
    );
    // if (message.msgType == 'chatgpt') {
    //   return SvgPicture.asset('assets/chatgpt-grey.svg');
    // } else {
    //   return SvgPicture.asset('assets/google-grey.svg');
    // }
  }

  @override
  Widget build(BuildContext context) {
    // if (message.role == 'user') {
    //   return userMessageBubble(context);
    // } else {
    //   return assistentMessageBubble(context);
    // }
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    DeviceType dt = getDeviceType();
    if (dt == DeviceType.small) {
      return MessageBlock(message: message);
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, left: 5),
            // margin: EdgeInsets.only(right: 10),
            width: 60,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                getMessageAvatar(context),
                // Expanded(child: SizedBox())
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 5, top: 10, bottom: 10),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: getMessageBackgroundColor(context, role: message.role),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(radius),
                  topLeft: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                ),
              ),
              // constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
              child: markDownWidgetWithStream(message, isDark),
            ),
          )
        ],
      );
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

  Color getMessageBackgroundColor(BuildContext context,
      {String role = "user"}) {
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    if (role == "user") {
      return Theme.of(context).colorScheme.background;
    }
    if (isDark) {
      return Colors.grey[900]!;
    } else {
      return Colors.black12;
    }
  }

  double radius = 3;

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

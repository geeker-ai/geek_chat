import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geek_chat/components/markdown/latex.dart';
import 'package:geek_chat/controller/message_block_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/message.dart';
// import 'package:geek_chat/repository/sessions_repository.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:markdown_widget/markdown_widget.dart';

// ignore: must_be_immutable
class MessageContent extends StatelessWidget {
  MessageModel message;
  MessageContent({super.key, required this.message}) {
    //
  }

  MessageBlockController controller = Get.put(MessageBlockController());
  Logger logger = Get.find();

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

  double radius = 3;

  @override
  Widget build(BuildContext context) {
    // if (message.role == 'user') {
    //   return userMessageBubble(context);
    // } else {
    //   return assistentMessageBubble(context);
    // }
    // bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    DeviceType dt = getDeviceType();
    if (dt == DeviceType.small) {
      return MessageBlock(message: message);
    } else {
      return buildWideScreenMessageBlock(context);
    }
  }

  double avatarWidth = 70;

  Widget buildWideScreenMessageBlock(BuildContext context) {
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    return GetBuilder<MessageBlockController>(builder: (controller) {
      return MouseRegion(
        onEnter: (event) {
          logger.d("on Enter: ${message.msgId}");
          controller.setDisplay(message.msgId, true);
          controller.update();
        },
        onExit: (event) {
          logger.d("on Exit");
          controller.setDisplay(message.msgId, false);
          controller.update();
        },
        child: Container(
          padding: const EdgeInsets.only(right: 5, bottom: 5),
          margin: const EdgeInsets.only(bottom: 10, right: 15, left: 10),
          decoration: BoxDecoration(
            color: getMessageBackgroundColor(context, role: message.role),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(radius),
              topLeft: Radius.circular(radius),
              bottomLeft: Radius.circular(radius),
              bottomRight: Radius.circular(radius),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    width: avatarWidth,
                    child: Column(
                      children: [
                        getMessageAvatar(context),
                        // Expanded(child: SizedBox())
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 3),
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(right: 8),
                      child: markDownWidgetWithStream(message, isDark),
                    ),
                  )
                ],
              ),
              displayMessageOpt(context),
            ],
          ),
        ),
      );
    });
  }

  double iconButtonSize = 20.0;

  Widget displayMessageOpt(BuildContext context) {
    late Color messsageTipsColor;
    bool offStage = false;

    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    if (isDark) {
      messsageTipsColor = Colors.grey[500]!;
    } else {
      messsageTipsColor = Colors.black54;
    }
    if (message.role == 'user') {
      // return Container();
      offStage = true;
    }
    return Container(
      padding: EdgeInsets.only(left: avatarWidth + 5, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Offstage(
            offstage: offStage,
            child: Row(
              children: [
                Text(
                  "model: ${message.model}",
                  style: TextStyle(color: messsageTipsColor, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 5, bottom: 0, left: 0, right: 0),
            margin: EdgeInsets.zero,
            height: 50,
            // width: double.infinity,
            decoration: BoxDecoration(
                color: getMessageBackgroundColor(context, role: message.role)),
            child: GetBuilder<MessageBlockController>(
              init: MessageBlockController(),
              builder: (controller) {
                return Opacity(
                  opacity: controller.isDisplay(message.msgId) ? 1 : 0,
                  child: UnconstrainedBox(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.only(top: 0, bottom: 0),
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: getMessageBackgroundColor(context,
                            role: message.role),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.background,
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: const Offset(1.0, 2.0),
                          )
                        ],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.copy_all_outlined),
                            iconSize: iconButtonSize,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.format_quote_outlined),
                            iconSize: iconButtonSize,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.delete_forever),
                            iconSize: iconButtonSize,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
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
            text = "$text ✍️";
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

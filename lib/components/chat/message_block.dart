import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geek_chat/components/chat/image_message_component.dart';
import 'package:geek_chat/components/markdown/code_warpper.dart';
import 'package:geek_chat/components/markdown/latex.dart';
import 'package:geek_chat/controller/chat_message_controller.dart';
import 'package:geek_chat/controller/message_block_controller.dart';
import 'package:geek_chat/models/message.dart';
import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/models/session.dart';
import 'package:geek_chat/util/app_constants.dart';
// import 'package:geek_chat/repository/sessions_repository.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';

class ItemModel {
  String title;
  IconData icon;
  Function onTap;

  ItemModel(this.title, this.icon, this.onTap);
}

// ignore: must_be_immutable
class MessageContent extends StatelessWidget {
  MessageModel message;
  SessionModel session;
  DeviceType deviceType;
  MessageContent({
    super.key,
    required this.message,
    required this.deviceType,
    required this.session,
    required this.onDelete,
    required this.moveTo,
    required this.aiModel,
    this.onQuote,
  }) {
    //
  }

  Function? onQuote;
  Function onDelete;
  Function moveTo;
  AiModel aiModel;

  // MessageBlockController controller = Get.put(MessageBlockController());
  Logger logger = Get.find();

  CustomPopupMenuController customPopupMenuController =
      CustomPopupMenuController();

  // Widget _buildLongPressMenu() {
  //   List<ItemModel> menuItems = [
  //     ItemModel("Copy", Icons.content_copy, (MessageModel msg) {
  //       Clipboard.setData(ClipboardData(text: msg.content));
  //     }),
  //     ItemModel("Delete", Icons.delete, (MessageModel msg) {
  //       onDelete(msg);
  //     }),
  //   ];

  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(5),
  //     child: Container(
  //       width: 90,
  //       color: const Color(0xFF4C4C4C),
  //       child: GridView.count(
  //         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
  //         crossAxisCount: menuItems.length,
  //         crossAxisSpacing: 0,
  //         mainAxisSpacing: 10,
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         children: menuItems
  //             .map((item) => GestureDetector(
  //                   onTap: () {
  //                     logger.d("gesture detector ${message.msgId}");
  //                     item.onTap(message);
  //                     customPopupMenuController.hideMenu();
  //                   },
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: <Widget>[
  //                       Icon(
  //                         item.icon,
  //                         size: 20,
  //                         color: Colors.white,
  //                       ),
  //                       Container(
  //                         margin: const EdgeInsets.only(top: 2),
  //                         child: Text(
  //                           item.title.tr,
  //                           style: const TextStyle(
  //                               color: Colors.white, fontSize: 12),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ))
  //             .toList(),
  //       ),
  //     ),
  //   );
  // }

  double getAvataSize() {
    if (deviceType == DeviceType.small) {
      return 24;
    }
    return 35;
  }

  Widget getMessageAvatar(BuildContext context) {
    if (message.role == 'user') {
      return Icon(
        Icons.person_outline_outlined,
        size: getAvataSize(),
      );
    }

    AiModel model = AppConstants.getAiModel(message.model!);

    String svgPic = 'assets/chatgpt-grey.svg';
    if (model.aiType.name == AiType.bard.name) {
      svgPic = 'assets/google-grey.svg';
    }
    return SvgPicture.asset(
      svgPic,
      width: getAvataSize(),
      height: getAvataSize(),
      colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.onBackground,
        BlendMode.srcIn,
      ),
    );
  }

  double radius = 3;

  @override
  Widget build(BuildContext context) {
    if (deviceType == DeviceType.small) {
      // return MessageBlock(message: message);
      return buildSmallScreenMessageBlock(context);
    } else {
      return buildWideScreenMessageBlock(context);
    }
  }

  double avatarWidth = 60;
  double getAvatarWidth() {
    if (deviceType == DeviceType.small) {
      return 34;
    }
    return avatarWidth;
  }

  Widget buildSmallScreenMessageBlock(BuildContext context) {
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    return GetBuilder<MessageBlockController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        margin: const EdgeInsets.only(right: 10, left: 10, top: 3, bottom: 3),
        decoration: BoxDecoration(
          color: getMessageBackgroundColor(context, role: message.role),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(radius),
            topLeft: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              width: getAvatarWidth(),
              child: Column(
                children: [
                  getMessageAvatar(context),
                ],
              ),
            ),
            Expanded(
              // child: markDownWidgetWithStream(message, isDark),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  messageContentAdaptor(message, controller, isDark),
                  if (message.hasImage)
                    buildImageBlock(context, message.imageUrl),
                ],
              ),
              // child: CustomPopupMenu(
              //   menuBuilder: _buildLongPressMenu,
              //   barrierColor: Colors.transparent,
              //   pressType: PressType.singleClick,
              //   controller: customPopupMenuController,
              //   position: PreferredPosition.top,
              //   child: Container(
              //     padding: const EdgeInsets.only(top: 3, bottom: 3),
              //     alignment: Alignment.centerLeft,
              //     margin: const EdgeInsets.only(right: 5),
              //     child: markDownWidgetWithStream(message, isDark),
              //   ),
              // ),
            )
          ],
        ),
      );
    });
  }

  Widget buildWideScreenMessageBlock(BuildContext context) {
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    return GetBuilder<MessageBlockController>(builder: (controller) {
      return MouseRegion(
        onEnter: (event) {
          // logger.d("on Enter: ${message.msgId}");
          controller.setDisplay(message.msgId, true);
          controller.update();
          // event.position
          controller.mousePosition = event.position;
        },
        onExit: (event) {
          // logger.d("on Exit");
          controller.setDisplay(message.msgId, false);
          controller.update();
        },
        child: Container(
          padding: const EdgeInsets.only(right: 15, bottom: 5),
          margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10, left: 5),
                    width: avatarWidth,
                    child: Column(
                      children: [
                        getMessageAvatar(context),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 3),
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(right: 8),
                          child: messageContentAdaptor(
                              message, controller, isDark),
                        ),
                        if (message.hasImage)
                          buildImageBlock(context, message.imageUrl),
                      ],
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

  Widget buildImageBlock(BuildContext context, String imageUrl) {
    Widget widget = Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        Container(
          // width: 512,
          height: 256,
          width: 256,
          padding: const EdgeInsets.only(bottom: 5),
          child: GestureDetector(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Hero(
                tag: message.msgId,
                child: ExtendedImage.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  cache: true,
                  cacheMaxAge: const Duration(days: 100000),
                  cacheRawData: true,
                  retries: 3,
                  timeLimit: const Duration(seconds: 10),
                  enableLoadState: true,
                  scale: 0.5,
                  // mode: ExtendedImageMode.gesture,
                  initGestureConfigHandler: (state) {
                    return GestureConfig(
                        inPageView: false,
                        initialScale: 1,
                        cacheGesture: false);
                  },
                  // scale: BorderSide.strokeAlignCenter,
                ),
              ),
            ),
            onTap: () {
              Get.toNamed("/image/view",
                  parameters: {"url": imageUrl, "id": message.msgId});
            },
          ),
        )
      ],
    );
    return widget;
  }

  Widget messageContentAdaptor(
      MessageModel message, MessageBlockController controller, bool isDark) {
    AiModel aiModel = controller.getAiModelbyName(message.model!);
    if (aiModel.modelType.name == ModelType.image.name) {
      return ImageMessageComponent(message: message);
    }
    return markDownWidgetWithStream(message, isDark);
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
                  "MODEL: ${message.model?.toUpperCase()}",
                  style: TextStyle(color: messsageTipsColor, fontSize: 12),
                ),
              ],
            ),
          ),
          QuoteMessageComponent(
            message: message,
            moveTo: moveTo,
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 5, bottom: 0, left: 0, right: 0),
            margin: EdgeInsets.zero,
            height: 50,
            // width: double.infinity,
            // decoration: BoxDecoration(
            // color: getMessageBackgroundColor(context, role: message.role),
            // ),
            child: GetBuilder<MessageBlockController>(
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
                        // color: Theme.of(context).colorScheme.background,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.background,
                            // color: Colors.black54,
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: isDark
                                ? const Offset(1.0, 2.0)
                                : const Offset(-1.0, -2.0),
                          )
                        ],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                      ),
                      child: Row(
                        children: getOptionButtons(context, message, session),
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

  List<Widget> getOptionButtons(
      BuildContext context, MessageModel message, SessionModel session) {
    List<Widget> buttons = [];
    // logger.d("session model type: ${session.modelType}");
    if ((message.role == "user" && session.modelType == ModelType.image.name) ||
        session.modelType != ModelType.image.name) {
      buttons.add(IconButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: message.content));
          showCustomToast(title: "Copied!".tr, context: context);
        },
        icon: const Icon(Icons.copy_all_outlined),
        iconSize: iconButtonSize,
        tooltip: "Copy".tr,
      ));
    }
    if (!(session.modelType == ModelType.image.name ||
            aiModel.aiType == AiType.bard) &&
        onQuote != null) {
      buttons.add(IconButton(
        onPressed: () {
          onQuote!(message);
        },
        icon: const Icon(Icons.format_quote_outlined),
        iconSize: iconButtonSize,
        tooltip: "Quote".tr,
      ));
    }

    buttons.add(IconButton(
      onPressed: () {
        Get.defaultDialog(
          title: "Delete Message".tr,
          onCancel: () {
            Get.back();
          },
          onConfirm: () {
            onDelete(message);
            Get.back();
          },
          textCancel: "Cancel".tr,
          textConfirm: "Confirm".tr,
          middleText: "Confirm delete message?".tr,
          radius: 5,
        );
      },
      icon: const Icon(Icons.delete_forever),
      iconSize: iconButtonSize,
      tooltip: "Delete".tr,
    ));

    return buttons;
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
class QuoteMessageComponent extends StatelessWidget {
  QuoteMessageComponent({
    super.key,
    required this.message,
    required this.moveTo,
  });

  MessageModel message;
  Function moveTo;

  ChatMessageController chatMessageController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (message.quotes == null) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Wrap(
        spacing: 3,
        runSpacing: 3,
        direction: Axis.horizontal,
        textDirection: TextDirection.ltr,
        children: [
          for (MessageModel message
              in chatMessageController.findQuoteMessages(message))
            ActionChip(
              tooltip: message.content,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              label: SizedBox(
                width: 150,
                child: Text(
                  message.content,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              padding: const EdgeInsets.all(0),
              onPressed: () {
                // moveTo(message);
              },
            ),
        ],
      ),
    );
  }
}

// @Deprecated("message")
// // ignore: must_be_immutable
// class MessageBlock extends StatelessWidget {
//   MessageModel message;
//   MessageBlock({super.key, required this.message});

//   MainAxisAlignment getMainAxisAligment() {
//     if (message.role == SettingsController.to.chatGPTRoles.assistant) {
//       return MainAxisAlignment.start;
//     } else {
//       return MainAxisAlignment.end;
//     }
//   }

//   BorderRadiusGeometry getBorderRadius() {
//     double radius = 10;
//     if (message.role == SettingsController.to.chatGPTRoles.assistant) {
//       return BorderRadius.only(
//         topRight: Radius.circular(radius),
//         topLeft: Radius.circular(radius),
//         // bottomLeft: Radius.circular(radius),
//         bottomRight: Radius.circular(radius),
//       );
//     } else {
//       return BorderRadius.only(
//         topLeft: Radius.circular(radius),
//         topRight: Radius.circular(radius),
//         bottomLeft: Radius.circular(radius),
//         // bottomRight: Radius.circular(radius),
//       );
//     }
//   }

//   final messageGap = 15.0;
//   double getMessageLeftSizedBoxWidth() {
//     if (message.role == SettingsController.to.chatGPTRoles.user) {
//       return messageGap;
//     }
//     return 0;
//   }

//   double getMessageRightSizedBoxWidth() {
//     if (message.role == SettingsController.to.chatGPTRoles.user) {
//       return 0;
//     }
//     return messageGap;
//   }

//   Color getMessageBackgroundColor(BuildContext context) {
//     bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
//     if (isDark) {
//       return Colors.grey[900]!;
//     } else {
//       return Colors.black12;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
//     return Padding(
//       padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
//       child: Row(
//         mainAxisAlignment: getMainAxisAligment(),
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: getMessageLeftSizedBoxWidth(),
//           ),
//           Expanded(
//             child: Container(
//               // width: double.infinity,
//               padding:
//                   const EdgeInsets.only(right: 5, left: 5, top: 10, bottom: 10),
//               decoration: BoxDecoration(
//                 color: getMessageBackgroundColor(context),
//                 borderRadius: getBorderRadius(),
//               ),
//               // constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
//               child: markDownWidgetWithStream(message, isDark),
//             ),
//           ),
//           SizedBox(
//             width: getMessageRightSizedBoxWidth(),
//           ),
//         ],
//       ),
//     );
//   }
// }

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

// Widget codeWrapper(Widget child, String text, String language) =>
//     CodeWrapperWidget(text: text, child: child);

Widget markDownWidget(String message, bool isDark) {
  final config =
      isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;

  codeWrapper(Widget child, String text, String language) =>
      CodeWrapperWidget(text: text, child: child);

  Widget markdownWidget = MarkdownWidget(
    data: message,
    shrinkWrap: true,
    // config: isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig,
    config: config.copy(configs: [
      isDark
          ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
          : const PreConfig().copy(wrapper: codeWrapper),
      TableConfig(
          wrapper: (table) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: table,
              )),
    ]),
    physics: const ScrollPhysics(),
    // markdownGeneratorConfig: MarkdownGeneratorConfig(
    //   generators: [latexGenerator],
    //   inlineSyntaxList: [LatexSyntax()],
    // ),
    markdownGenerator: MarkdownGenerator(
      generators: [latexGenerator],
      inlineSyntaxList: [LatexSyntax()],
    ),
  );
  return markdownWidget;
}

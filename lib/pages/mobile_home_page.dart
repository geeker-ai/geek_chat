import 'package:flutter/material.dart';
import 'package:geek_chat/components/chat_list_component.dart';
import 'package:geek_chat/components/main_settings_component.dart';
import 'package:geek_chat/controller/main_controller.dart';
import 'package:get/get.dart';

class MobileHomePage extends StatelessWidget {
  const MobileHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(const SettingsComponent());
    Get.put(const ChatListComponent());

    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<MainController>(builder: (controller) {
          return Text(controller.getTitle().tr);
        }),
        actions: [
          GetBuilder<MainController>(builder: (controller) {
            return appBarAddChatAction(controller.navIndex);
          }),
          const SizedBox(width: 5.0)
        ],
      ),
      bottomNavigationBar: GetBuilder<MainController>(builder: (controller) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            controller.navIndex = value;
            controller.update();
          },
          currentIndex: controller.navIndex,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat_rounded),
              label: 'Chat'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.smart_toy),
              label: 'Prompts'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: 'Settings'.tr,
            )
          ],
        );
      }),
      body: GetBuilder<MainController>(builder: (controller) {
        return navigationRoute(controller.navIndex);
      }),
    );
  }
}

Widget appBarAddChatAction(int index) {
  Widget widget = const SizedBox();
  if (index == 0) {
    widget = IconButton(
        onPressed: () {
          Get.toNamed('/editchat', parameters: {'opt': 'new', 'sid': ''});
        },
        icon: const Icon(Icons.add));
  }
  return widget;
}

Widget navigationRoute(int index) {
  Widget widget = const Text("data");
  switch (index) {
    case 0:
      // widget = Text("data $index");
      widget = Get.find<ChatListComponent>();
      break;
    case 1:
      widget = Text("data $index");
      break;
    case 2:
    // widget = Text("data $index");
    // break;
    default:
      widget = Get.find<SettingsComponent>();
  }
  return widget;
}

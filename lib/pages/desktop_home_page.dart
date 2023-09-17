import 'package:flutter/material.dart';
import 'package:geek_chat/components/chat/chat_list_menu_item.dart';
import 'package:geek_chat/components/chat/menu_button.dart';
import 'package:geek_chat/components/desktop_main_right_component.dart';
import 'package:geek_chat/controller/chat_list_controller.dart';
import 'package:get/get.dart';

class DesktopHomePage extends StatelessWidget {
  const DesktopHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ChatListController chatListController = Get.find();
    // if (chatListController.currentSession?) {
    //   //
    // }

    // if (chatListController.currentSession)

    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 8, bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 240,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1))),
                    onPressed: () {
                      //TODO new chat
                      Get.toNamed('/editchat',
                          parameters: {'opt': 'new', 'sid': ''});
                    },
                    label: const Text("New Chat"),
                    icon: const Icon(Icons.add),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: GetBuilder<ChatListController>(builder: (controller) {
                    return ListView.builder(
                        itemCount: controller.sessions.length,
                        controller: ScrollController(),
                        itemBuilder: (BuildContext ctxt, int index) {
                          // return Text(
                          //     controller.sessions.elementAt(index).name);
                          return ChatListMenuItemComponent(
                              session: controller.sessions.elementAt(index),
                              onTap: (String sid) {
                                controller.switchSession(sid);
                                controller.update();
                              },
                              currentSession: controller.currentSession);
                        });
                  }),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 5, right: 10),
                  child: Divider(),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(children: [
                    LeftMenuButtonComponent(
                        title: "Settings".tr,
                        onPressed: () {
                          Get.toNamed("/dsettings");
                        }),
                    LeftMenuButtonComponent(
                        title: "About Me".tr,
                        onPressed: () {
                          // Get.toNamed("/settings");
                        }),
                  ]),
                ),
              ],
            ),
          ),
          Container(
            width: 0.5,
            // color: Colors.black,
          ),
          Expanded(
            child: GetBuilder<ChatListController>(builder: (controller) {
              return chatListController.currentSessionId.isEmpty
                  ? Text("data")
                  : DeskTopMainRightComponent(
                      sid: chatListController.currentSession.sid);
            }),
          )
        ],
      ),
    );
  }
}

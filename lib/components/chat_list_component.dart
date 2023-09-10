import 'package:flutter/material.dart';
import 'package:geek_chat/controller/chat_list_controller.dart';
import 'package:geek_chat/models/session.dart';
import 'package:get/get.dart';

class ChatListComponent extends StatelessWidget {
  const ChatListComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatListController>(builder: ((controller) {
      return ListView(
        padding: const EdgeInsets.only(
            left: 10.0, top: 0.0, right: 20.0, bottom: 0.0),
        children: [
          for (SessionModel sm in controller.sessions)
            Text("title: ${sm.name} "),
        ],
      );
    }));
  }
}

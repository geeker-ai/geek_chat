import 'package:flutter/material.dart';
import 'package:geek_chat/controller/chat_controller.dart';
import 'package:get/get.dart';

class ChatListComponent extends StatelessWidget {
  const ChatListComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: ((controller) {
      return const Text("Chat List Component. ");
    }));
  }
}

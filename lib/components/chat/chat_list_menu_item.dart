import 'package:flutter/material.dart';
import 'package:geek_chat/models/session.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ChatListMenuItemComponent extends StatelessWidget {
  ChatListMenuItemComponent(
      {super.key,
      required this.session,
      required this.onTap,
      required this.currentSession});

  SessionModel session;
  SessionModel? currentSession;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    bool isSelected = currentSession?.sid == session.sid ? true : false;
    return PopupMenuItem<String>(
      padding: const EdgeInsets.all(0),
      // value: session.sid,
      child: ListTile(
        title: Text(session.name),
        leading: const Icon(Icons.chat_bubble_outline),
        onTap: () {
          onTap(session.sid);
        },
        // selected: isSelected,
        tileColor: isSelected ? Get.theme.colorScheme.primary : null,
      ),
      // onTap: () {},
    );
  }
}

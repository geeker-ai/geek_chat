import 'package:flutter/material.dart';
import 'package:geek_chat/models/session.dart';

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
    return PopupMenuItem(
      padding: const EdgeInsets.all(0),
      // value: session.sid,
      child: ListTile(
        title: Text(session.name),
        selectedTileColor: const Color.fromARGB(50, 84, 77, 77),
        leading: const Icon(Icons.chat_bubble_outline),
        onTap: () {
          onTap(session.sid);
        },
        selected: isSelected,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        // tileColor: isSelected ? Get.theme.colorScheme.primary : null,
      ),
      // onTap: () {},
    );
  }
}

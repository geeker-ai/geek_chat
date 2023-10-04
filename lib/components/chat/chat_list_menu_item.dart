import 'package:flutter/material.dart';
import 'package:geek_chat/models/session.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ChatListMenuItemComponent extends StatelessWidget {
  ChatListMenuItemComponent(
      {super.key,
      required this.session,
      required this.onTap,
      required this.currentSession,
      required this.onDelete});

  SessionModel session;
  SessionModel? currentSession;
  Function onTap;
  Function onDelete;

  @override
  Widget build(BuildContext context) {
    bool isSelected = currentSession?.sid == session.sid ? true : false;
    return PopupMenuItem(
      padding: const EdgeInsets.all(0),
      height: 42,
      // value: session.sid,
      child: ListTile(
        minVerticalPadding: 0,
        visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
        contentPadding:
            const EdgeInsets.only(right: 2, left: 16, top: 0, bottom: 0),
        title: buildMenuItem(context, isSelected, onDelete),
        selectedTileColor: const Color.fromARGB(50, 84, 77, 77),
        leading: const Icon(Icons.chat_bubble_outline),
        onTap: () {
          onTap(session.sid);
        },
        selected: isSelected,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),
    );
  }

  Widget buildMenuItem(
      BuildContext context, bool isSelected, Function onDelete) {
    return Row(
      children: [
        Expanded(
            child: Text(
          session.name,
          overflow: TextOverflow.ellipsis,
        )),
        if (isSelected)
          SizedBox(
            width: 30,
            height: 30,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Get.toNamed('/editchat',
                    parameters: {'opt': 'edit', 'sid': session.sid});
              },
              icon: const Icon(Icons.edit),
              iconSize: 16,
            ),
          ),
        if (isSelected)
          SizedBox(
            width: 30,
            height: 30,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Get.defaultDialog(
                  title: "Delete Session".tr,
                  onCancel: () {
                    Get.back();
                  },
                  onConfirm: () {
                    onDelete(session);
                    Get.back();
                  },
                  textCancel: "Cancel".tr,
                  textConfirm: "Confirm".tr,
                  middleText: "Confirm delete session?".tr,
                  radius: 5,
                );
              },
              icon: const Icon(Icons.delete_forever),
              iconSize: 16,
            ),
          ),
      ],
    );
  }
}

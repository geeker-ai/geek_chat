import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geek_chat/controller/chat_session_controller.dart';
import 'package:geek_chat/controller/chat_message_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/controller/tracker_controller.dart';
import 'package:geek_chat/models/model.dart';
import 'package:geek_chat/models/session.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ChatSessionsComponent extends StatelessWidget {
  ChatSessionsComponent({super.key});

  ChatMessageController chatMessageController =
      Get.find<ChatMessageController>();
  TrackerController tracker = Get.find();
  SettingsController settingsController = Get.find();

  // TODO: 重复代码
  Widget leadingIcon(BuildContext context, SessionModel session) {
    if (session.modelType == ModelType.image.name) {
      return const Icon(Icons.image_outlined);
    }
    return const Icon(Icons.chat_bubble_outline);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatSessionController>(builder: ((controller) {
      return ListView(
        padding: const EdgeInsets.only(
            left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
        children: [
          for (SessionModel sm in controller.sessions)
            Slidable(
              key: ValueKey("itemid-${sm.sid}"),
              // ignore: sort_child_properties_last
              child: SizedBox(
                // height: 58,
                child: ListTile(
                  // dense: true,
                  visualDensity: const VisualDensity(vertical: -3),
                  title: Text(
                    sm.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    sm.promptContent,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  leading: leadingIcon(context, sm),
                  trailing: const Icon(Icons.chevron_right_outlined),
                  onTap: () {
                    Get.toNamed('/chat', parameters: {'sid': sm.sid});
                    tracker.trackEvent("switchSession",
                        {"uuid": settingsController.settings.uuid});
                  },
                ),
              ),
              endActionPane:
                  ActionPane(motion: const ScrollMotion(), children: [
                SlidableAction(
                  onPressed: (value) {
                    // controller.remove(sm.sid);
                    chatMessageController.cleanSessionMessages(sm.sid);
                    controller.remove(sm);
                    controller.reloadSessions();
                    controller.update();
                  },
                  icon: Icons.delete,
                  label: 'Delete'.tr,
                ),
                SlidableAction(
                  onPressed: (value) {
                    Get.toNamed('/editchat',
                        parameters: {'opt': 'edit', 'sid': sm.sid});
                  },
                  icon: Icons.mode_edit_outline,
                  label: 'Edit'.tr,
                )
              ]),
            )
        ],
      );
    }));
  }
}

import 'package:flutter/material.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/bottom_switcher_model.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class GroupedBottomSheetSwitcherComponent extends StatelessWidget {
  GroupedBottomSheetSwitcherComponent(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.selectedValue,
      required this.options,
      required this.leadingIcon,
      required this.onTapCallback});

  String title;
  String subTitle;
  String selectedValue;
  Logger logger = Get.find();
  // List<Map<String, String>> options;
  List<GroupedBottomSwitcherOption> options;
  Function onTapCallback;
  IconData leadingIcon;

  List<Widget> buildOptionsList(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(ListTile(
      dense: true,
      title: Text(
        title.tr,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      tileColor: Theme.of(context).scaffoldBackgroundColor,
    ));
    for (GroupedBottomSwitcherOption group in options) {
      widgets.add(ListTile(
        dense: true,
        title: Text(group.groupName),
      ));
      for (BottomSwitcherOption option in group.options) {
        if (option.disabled) {
          widgets.add(ListTile(
            title: Row(
              children: [
                Radio(
                  value: option.id,
                  groupValue: selectedValue,
                  onChanged: null,
                ),
                Text(
                  option.name.tr,
                ),
              ],
            ),
          ));
        } else {
          widgets.add(ListTile(
            title: Row(
              children: [
                Radio(
                  value: option.id,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    onTapCallback(value);
                    Navigator.pop(context);
                  },
                ),
                Text(
                  option.name.tr,
                ),
              ],
            ),
            onTap: () {
              ///
              onTapCallback(option.id);
              Navigator.pop(context);
            },
          ));
        }
      }
    }

    widgets.add(Container(
      padding: const EdgeInsets.only(top: 20),
    ));
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    logger.d("options: $options");
    return GetBuilder<SettingsController>(builder: ((controller) {
      return ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.tr),
            Text(
              subTitle.tr,
              style: const TextStyle(fontSize: 12),
            )
          ],
        ),
        leading: Icon(leadingIcon),
        trailing: const Icon(Icons.chevron_right_outlined),
        onTap: () {
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: buildOptionsList(context),
                    ),
                  ),
                );
              });
        },
      );
    }));
  }
}

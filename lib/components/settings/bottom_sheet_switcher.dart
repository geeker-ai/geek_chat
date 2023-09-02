import 'package:flutter/material.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class BottomSheetSwitcherComponent extends StatelessWidget {
  BottomSheetSwitcherComponent(
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
  List<Map<String, String>> options;
  Function onTapCallback;
  IconData leadingIcon;

  @override
  Widget build(BuildContext context) {
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
              builder: (context) {
                return SafeArea(
                    child: Wrap(
                  children: [
                    ListTile(
                      dense: true,
                      title: Text(
                        title.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      tileColor: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    for (Map<String, String> item in options)
                      ListTile(
                        title: Row(
                          children: [
                            Radio(
                              value: item['name'],
                              groupValue: selectedValue,
                              onChanged: (value) {
                                onTapCallback(value);
                                Navigator.pop(context);
                              },
                            ),
                            Text(
                              "${item['title']}".tr,
                            ),
                          ],
                        ),
                        onTap: () {
                          ///
                          onTapCallback(item['name']);
                          Navigator.pop(context);
                        },
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ));
              });
        },
      );
    }));
  }
}

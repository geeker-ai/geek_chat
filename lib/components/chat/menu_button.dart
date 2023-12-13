import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
// import 'package:get/get.dart';
// import 'package:logger/logger.dart';
// import 'package:get/get.dart';

// ignore: must_be_immutable
class LeftMenuButtonComponent extends StatelessWidget {
  LeftMenuButtonComponent({
    super.key,
    required this.title,
    // required this.routeName,
    required this.onPressed,
    required this.icon,
    this.needNotice,
  });

  String title;
  Function onPressed;
  IconData icon;
  bool? needNotice;
  // String routeName;
  // Logger logger = Get.find();

  Widget getLabelTitle() {
    // logger.d("getLabelTitle $needNotice");
    if (needNotice != null && needNotice == true) {
      // return Row(
      //   children: [Text(title), Text("*")],
      // );
      return badges.Badge(
        position: badges.BadgePosition.topEnd(top: 0, end: -12),
        showBadge: true,
        child: Text(title),
      );
    }
    return Text(title);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 35),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
        ),
        onPressed: () {
          // Get.toNamed(routeName);
          onPressed();
        },
        icon: Icon(icon),
        label: getLabelTitle(),
      ),
    );
  }
}

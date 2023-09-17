import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LeftMenuButtonComponent extends StatelessWidget {
  LeftMenuButtonComponent(
      {super.key,
      required this.title,
      // required this.routeName,
      required this.onPressed});

  String title;
  Function onPressed;
  // String routeName;

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
        icon: const Icon(Icons.settings),
        label: Text(title),
      ),
    );
  }
}

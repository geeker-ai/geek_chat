import 'package:flutter/material.dart';
import 'package:geek_chat/controller/main_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  MainController mainController = Get.find();
  SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About".tr),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(
                "Geek Chat (v${settingsController.packageInfo.version})",
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: Text("Geeker Chat Intro".tr),
              ),
            ),
            for (ChangeLogModel version in mainController.versions)
              ExpansionTile(
                title: Text(version.version),
                controlAffinity: ListTileControlAffinity.leading,
                expandedAlignment: Alignment.centerLeft,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(left: 35, top: 5, bottom: 10),
                    child: Text(version.content),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}

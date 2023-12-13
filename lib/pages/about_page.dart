import 'package:flutter/material.dart';
import 'package:geek_chat/controller/main_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/controller/tracker_controller.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/markdown_widget.dart';

// ignore: must_be_immutable
class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  MainController mainController = Get.find();
  SettingsController settingsController = Get.find();
  TrackerController tracker = Get.find();

  @override
  Widget build(BuildContext context) {
    tracker
        .trackEvent("Page-About", {"uuid": settingsController.settings.uuid});
    ChangeLogModel lastVersion = mainController.versions.first;
    List<ChangeLogModel> changeLogs = [];
    changeLogs.addAll(mainController.versions);
    changeLogs.removeAt(0);
    return Scaffold(
      appBar: AppBar(
        title: Text("About".tr),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MarkdownWidget(
                        data: "Geeker Chat Intro".tr,
                        shrinkWrap: true,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: const MarkdownWidget(
                          data:
                              "Download Link: https://github.com/geeker-ai/geek_chat/releases",
                          shrinkWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "${lastVersion.version} (Latest Version)",
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleLarge?.fontSize),
                ),
                dense: true,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                  child: MarkdownWidget(
                    data: lastVersion.content,
                    shrinkWrap: true,
                  ),
                ),
              ),
              for (ChangeLogModel version in changeLogs)
                ExpansionTile(
                  title: Text(version.version),
                  controlAffinity: ListTileControlAffinity.leading,
                  expandedAlignment: Alignment.centerLeft,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(left: 35, top: 5, bottom: 10),
                      // child: Text(version.content),
                      child: MarkdownWidget(
                        data: version.content,
                        shrinkWrap: true,
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}

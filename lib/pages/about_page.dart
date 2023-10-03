import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});

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
                //
                ),
            ExpansionTile(
              title: const Text("v0.0.43"),
              controlAffinity: ListTileControlAffinity.leading,
              expandedAlignment: Alignment.centerLeft,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 35, top: 5, bottom: 10),
                  child: const Text("1.支持OpenAI的gpt3.5, gpt4模型\n2.支持手机端桌面端同构"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

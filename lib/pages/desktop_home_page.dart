import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DesktopHomePage extends StatelessWidget {
  const DesktopHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 8, bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 240,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1))),
                    onPressed: () {
                      //TODO new chat
                    },
                    label: const Text("New Chat"),
                    icon: const Icon(Icons.add),
                  ),
                ),
                const Expanded(child: Text("Chat List")),
                const Padding(
                  padding: EdgeInsets.only(left: 5, right: 10),
                  child: Divider(),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(children: [
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 35),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1)),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.settings),
                        label: Text("Settings".tr),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: TextButton.icon(
                          style: TextButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 35),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1)),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.info_outline),
                          label: Text("About me".tr)),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          Container(
            width: 0.5,
            color: Colors.black,
          ),
          const Expanded(child: Text("data"))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileHomePage extends StatelessWidget {
  const MobileHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'.tr),
      ),
      drawer: Drawer(
        elevation: 8,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'appTitle'.tr,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    )
                  ],
                ),
                Divider(
                  color: Theme.of(Get.context!).colorScheme.primary,
                  thickness: 0.5,
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        title: Text('Chat'.tr),
                        leading: const Icon(Icons.forum),
                        onTap: () {
                          Get.back();
                        },
                      ),
                      ListTile(
                        title: Text('Settings'.tr),
                        leading: const Icon(Icons.settings),
                        onTap: () {
                          Get.toNamed('/settings');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

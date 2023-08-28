import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geek_chat/pages/unkown_page.dart';
import 'package:get/route_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:geek_chat/routers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 900),
      center: true,
      windowButtonVisibility: false,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  initServices();
  runApp(const GeekerChat());
}

initServices() async {
  // TODO
}

class GeekerChat extends StatelessWidget {
  const GeekerChat({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/mobile',
      getPages: routers,
      unknownRoute: GetPage(
        name: '/404',
        page: () => const UnkownRoutePage(),
      ),
    );
  }
}

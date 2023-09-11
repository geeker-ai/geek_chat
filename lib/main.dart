import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geek_chat/controller/chat_list_controller.dart';
import 'package:geek_chat/controller/main_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/i18n/translations.dart';
import 'package:geek_chat/pages/unkown_page.dart';
import 'package:geek_chat/repository/localstore_repository.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:geek_chat/routers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitUp, // 竖屏 Portrait 模式
  //     DeviceOrientation.portraitDown,
  //     // DeviceOrientation.landscapeLeft, // 横屏 Landscape 模式
  //     // DeviceOrientation.landscapeRight,
  //   ],
  // );
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
  // print("system locale: ${Get.deviceLocale}");
  await GetStorage.init('geekchat');
  await initServices();
  runApp(const GeekerChat());
}

initServices() async {
  // TODO zh_Hans_CN, en_US
  Get.put(LocalStoreRepository());
  Directory dir = await getApplicationDocumentsDirectory();
  Get.put(SettingsController());
  SettingsController.to.dataDir = dir;

  Get.put(MainController());
  Get.put(ChatListController());
}

class GeekerChat extends StatelessWidget {
  const GeekerChat({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: routers,
      unknownRoute: GetPage(
        name: '/404',
        page: () => const UnkownRoutePage(),
      ),

      theme: FlexThemeData.light(
        scheme: FlexScheme.materialBaseline,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useTextTheme: true,
          // useM2StyleDividerInM3: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        // swapLegacyOnMaterial3: true,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.materialBaseline,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        // blendLevel: 13,
        useMaterial3: true,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useTextTheme: true,
          // useM2StyleDividerInM3: true,
        ),
      ),
      // theme: ThemeData.light(useMaterial3: true),
      // darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: SettingsController.to.getThemeMode(),
      locale: Locale(SettingsController.to.settings.language),
      translations: GeekChatTranslations(),
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.rightToLeft,
    );
  }
}
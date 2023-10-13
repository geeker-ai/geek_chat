import 'dart:io';
// import 'dart:math';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiktoken/flutter_tiktoken.dart';
// import 'package:flutter_gpt_tokenizer/flutter_gpt_tokenizer.dart';
import 'package:geek_chat/controller/chat_list_controller.dart';
import 'package:geek_chat/controller/chat_message_controller.dart';
import 'package:geek_chat/controller/main_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/controller/settings_server_controller.dart';
import 'package:geek_chat/i18n/translations.dart';
import 'package:geek_chat/models/release.dart';
import 'package:geek_chat/pages/unkown_page.dart';
import 'package:geek_chat/repository/localstore_repository.dart';
import 'package:geek_chat/repository/sessions_repository.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
    // WindowOptions windowOptions = const WindowOptions(
    //     // size: Size(1280, 900),
    //     // center: true,
    //     // windowButtonVisibility: false,
    //     minimumSize: Size(800, 600));
    // windowManager.waitUntilReadyToShow(windowOptions, () async {
    //   await windowManager.show();
    //   await windowManager.focus();
    // });
    windowManager.setMinimumSize(const Size(800, 600));
  }
  // print("system locale: ${Get.deviceLocale}");

  await initServices();
  runApp(GeekerChat(
    mainRouters: routers,
  ));
}

initServices() async {
  // TODO zh_Hans_CN, en_US

  await dotenv.load(fileName: ".env");

  Logger logger = Get.put(Logger());
  logger.d("env: channel: ${dotenv.get('CHANNEL')}");

  String storeageName = "geekchat3";

  await GetStorage.init(storeageName);

  Get.put(LocalStoreRepository(storageName: storeageName));
  // Get.put(HttpClientService());
  Directory dir = await getApplicationDocumentsDirectory();
  logger.d("Application Documents Directory: $dir ");
  Get.put(SessionRepository(dir));
  SettingsController settingsController = Get.put(SettingsController());
  SettingsController.to.dataDir = dir;
  settingsController.deviceType = getDeviceType();

  ///SettingsServerController settingsServerController =
  Get.put(
      SettingsServerController(provider: settingsController.settings.provider));

  MainController mainController = Get.put(MainController());
  mainController.loadChangeLog();
  Get.put(ChatListController());
  Get.put(ChatMessageController());
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  settingsController.packageInfo = packageInfo;

  // EventBus eventBus = Get.put(EventBus());
  // listen language change event;
  // eventBus.on<LanguageModel>().listen((event) {
  //   mainController.initPrompts().then((value) {
  //     logger.d("init prompts finished!");
  //     mainController.update();
  //   });
  // });
  // eventBus.fire(LanguageModel(name: 'name'));

  // dotenv.load(fileName: ".env");

  // logger.d(dotenv.get("CHANNEL"));
  logger.d("Channel name: ${settingsController.channelName}");

  TiktokenDataProcessCenter().initata();

  /// check update only
  if (settingsController.channelName == "site") {
    mainController.checkUpdate(settingsController.packageInfo.version,
        (ReleaseModel releaseModel) {
      String tip = "Found a new version".tr;
      Get.defaultDialog(
          title: "Update!".tr,
          textConfirm: "Download".tr,
          textCancel: "Cancel".tr,
          onCancel: () => Get.back(),
          onConfirm: () {
            logger.d("confirm click");
            launchUrl(
                Uri.parse("https://github.com/geeker-ai/geek_chat/releases"));
          },
          radius: 5,
          middleText: "$tip : ${releaseModel.version}");
    });
  }

  mainController.initPrompts();
}

// class GeekChat extends StatelessWidget {
//   GeekChat({super.key, required this.mainRouters});

//   List<GetPage<dynamic>> mainRouters;

//   @override
//   Widget build(BuildContext context) {
//     return FluentApp(
//       routes: mainRouters,
//     );
//   }
// }

// ignore: must_be_immutable
class GeekerChat extends StatelessWidget {
  GeekerChat({super.key, required this.mainRouters});

  List<GetPage<dynamic>> mainRouters;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: mainRouters,
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

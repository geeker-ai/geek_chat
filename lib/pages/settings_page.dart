// import 'package:flutter/material.dart';
// import 'package:geek_chat/controller/locale_controller.dart';
// import 'package:geek_chat/controller/settings.dart';
// import 'package:geek_chat/models/locale_model.dart';
// import 'package:geek_chat/models/theme.dart';
// import 'package:get/get.dart';
// import 'package:logger/logger.dart';

// // ignore: must_be_immutable
// class SettingsPage extends StatelessWidget {
//   SettingsPage({super.key});

//   Logger logger = Get.find<Logger>();
//   final LocaleController localeController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     SettingsController.to.resetSettings();
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Settings'.tr),
//         ),
//         body: GetBuilder<SettingsController>(
//           builder: (controller) {
//             return ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 const Divider(),
//                 ListTile(
//                   dense: true,
//                   title: Text(
//                     'theme'.tr,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 for (GCThemeMode themeMode in controller.themeModes)
//                   RadioListTile(
//                       title: Text(themeMode.name.tr),
//                       value: themeMode.name,
//                       groupValue: controller.settings.theme,
//                       onChanged: (value) {
//                         controller.settings.theme = themeMode.name;
//                         // controller.changeSettings();
//                         controller.update();
//                         // print(SettingsController.to.settings.theme);
//                         logger.d(
//                             "SettingsController.to.settings.theme: ${SettingsController.to.settings.theme}");
//                       }),
//                 const Divider(),
//                 ListTile(
//                   dense: true,
//                   title: Text('Language'.tr,
//                       style: const TextStyle(fontWeight: FontWeight.bold)),
//                 ),
//                 for (LocaleModel element in localeController.locales)
//                   RadioListTile(
//                       title: Text(element.languageName.tr),
//                       value: element.id,
//                       groupValue: localeController.locale.id,
//                       onChanged: (value) {
//                         // controller.settings.language = element.locale;
//                         logger.d("set locale: $value");
//                         localeController.setLocale(element.id);
//                         // controller.changeSettings();
//                         controller.update();
//                       }),
//                 const Divider(),
//                 Row(
//                   // crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     OutlinedButton(
//                         child: Text("Save".tr),
//                         onPressed: () {
//                           controller.save();
//                         }),
//                     const SizedBox(width: 30.0),
//                     OutlinedButton(
//                         child: Text("Cancel".tr),
//                         onPressed: () {
//                           Get.back();
//                         }),
//                   ],
//                 ),
//               ],
//             );
//           },
//         ));
//   }
// }

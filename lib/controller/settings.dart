import 'package:flutter/material.dart';
import 'package:geek_chat/models/settings.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final isObscure = true.obs;

  final settings = SettingsModel().obs;

  final themeMode = ThemeMode.dark;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}

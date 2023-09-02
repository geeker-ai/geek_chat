// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:geek_chat/pages/mobile_home_page.dart';
import 'package:geek_chat/pages/settings/server_settings.dart';
import 'package:geek_chat/util/functions.dart';
import 'package:get/route_manager.dart';

final routers = [
  GetPage(
      name: '/',
      page: () {
        DeviceType dt = getDeviceType();
        if (dt == DeviceType.small) {
          return const MobileHomePage();
        }
        return const MobileHomePage();
      }),
  GetPage(name: '/settings', page: () => ServerSettingsPage()),
];

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:geek_chat/pages/chat_edit.dart';
import 'package:geek_chat/pages/chat_message_page.dart';
import 'package:geek_chat/pages/desktop_home_page.dart';
import 'package:geek_chat/pages/mobile_home_page.dart';
import 'package:geek_chat/pages/settings/desktop_settings_page.dart';
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
        return const DesktopHomePage();
      }),
  GetPage(name: '/settings', page: () => ServerSettingsPage()),
  GetPage(
      name: '/dsettings',
      page: () {
        return const DesktopSettingsPage();
      }),
  GetPage(name: '/editchat', page: () => ChatEditPage()),
  GetPage(name: '/chat', page: () => ChatMessagePage())
];

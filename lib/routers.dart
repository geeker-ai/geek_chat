import 'package:geek_chat/pages/mobile_home.dart';
import 'package:geek_chat/pages/settings_page.dart';
import 'package:get/route_manager.dart';

final routers = [
  GetPage(name: '/', page: () => const MobileHomePage()),
  GetPage(name: '/settings', page: () => SettingsPage()),
];

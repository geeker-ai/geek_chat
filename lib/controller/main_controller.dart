import 'package:get/get.dart';

class MainController extends GetxController {
  static MainController get to => Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  int _navIndex = 0;

  final menus = [
    {"title": "Chat"},
    {"title": "Prompts"},
    {"title": "Settings"}
  ];

  int get navIndex {
    return _navIndex;
  }

  String getTitle() {
    return "${menus[_navIndex]['title']}";
  }

  set navIndex(int index) {
    _navIndex = index;
    update();
  }
}

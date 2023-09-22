import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ChatMessageScrollController extends GetxController {
  Logger logger = Get.find();
  GlobalKey listViewKey = GlobalKey();
  late ScrollController scrollController;
  bool showGotoTopBtn = false;
  bool showGotoBottomBtn = false;

  void initScrollButton() {
    scrollListener();
  }

  void scrollListener() {
    final extentAfter = scrollController.position.extentAfter;
    bool showGotoTopBtnLocal = showGotoTopBtn;
    bool showGotoBottomBtnLocal = showGotoBottomBtn;
    if (extentAfter < 10) {
      showGotoTopBtnLocal = false;
    } else {
      showGotoTopBtnLocal = true;
    }

    if (scrollController.position.maxScrollExtent - extentAfter <= 10) {
      showGotoBottomBtnLocal = false;
    } else {
      showGotoBottomBtnLocal = true;
    }
    // update();
    // print("object");
    if (showGotoBottomBtnLocal != showGotoBottomBtn) {
      showGotoBottomBtn = showGotoBottomBtnLocal;
      update();
    }
    if (showGotoTopBtnLocal != showGotoTopBtn) {
      showGotoTopBtn = showGotoTopBtnLocal;
      update();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ChatMessageScrollController extends GetxController {
  Logger logger = Get.find();
  GlobalKey listViewKey = GlobalKey();
  bool showGotoTopBtn = false;
  bool showGotoBottomBtn = false;
}

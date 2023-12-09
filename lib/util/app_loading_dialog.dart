import 'package:flutter/material.dart';
import 'package:loading_progress/loading_progress.dart';

class AppLoadingProgress {
  static start(BuildContext context) {
    LoadingProgress.start(context);
  }

  static stop(BuildContext context) {
    LoadingProgress.stop(context);
  }
}

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GeekChatImageViewerPage extends StatelessWidget {
  const GeekChatImageViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    var parameters = Get.parameters;
    String imageUrl = parameters['url']!;
    return Material(
      color: Colors.transparent,
      child: ExtendedImageSlidePage(
        child: GestureDetector(
          child: ExtendedImage.network(
            imageUrl,
            cache: true,
            enableLoadState: true,
          ),
          onTap: () {
            Get.back();
          },
        ),
      ),
    );
  }
}

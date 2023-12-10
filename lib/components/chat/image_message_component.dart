import 'package:dart_openai/dart_openai.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_chat/models/message.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ImageMessageComponent extends StatelessWidget {
  ImageMessageComponent({super.key, required this.message});
  MessageModel message;
  @override
  Widget build(BuildContext context) {
    if (message.role == "user") {
      return Text(message.content);
    }
    // return Text(message.openAIImageModel!.data.first.revisedPrompt!);
    return buildResponseComponent(context);
  }

  Widget buildResponseComponent(BuildContext context) {
    OpenAIImageModel? openAIImageModel = message.openAIImageModel;
    // int currentIndex = 0;
    if (openAIImageModel == null) {
      return Text(message.content);
    }
    String imageUrl = message.openAIImageModel!.data.first.url!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(message.openAIImageModel!.data.first.revisedPrompt!),
        ),
        Wrap(
          children: [
            Container(
              // width: 512,
              height: 256,
              padding: const EdgeInsets.only(bottom: 5),
              child: GestureDetector(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Hero(
                    tag: message.msgId,
                    child: ExtendedImage.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      cache: true,
                      retries: 3,
                      timeLimit: const Duration(seconds: 10),
                      enableLoadState: true,
                      scale: 0.5,
                      // mode: ExtendedImageMode.gesture,
                      initGestureConfigHandler: (state) {
                        return GestureConfig(
                            inPageView: false,
                            initialScale: 1,
                            cacheGesture: false);
                      },
                      // scale: BorderSide.strokeAlignCenter,
                    ),
                  ),
                ),
                onTap: () {
                  Get.toNamed("/image/view",
                      parameters: {"url": imageUrl, "id": message.msgId});
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}

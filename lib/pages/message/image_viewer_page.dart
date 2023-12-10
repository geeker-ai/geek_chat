import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

///https://dosomthings.com/how-to-download-and-save-image-to-file-in-flutter/
// ignore: must_be_immutable
class GeekChatImageViewerPage extends StatelessWidget {
  GeekChatImageViewerPage({super.key});

  Logger logger = Get.find();

  // Directory getDirectory() async {
  //   Directory? downloadDir = await getDownloadsDirectory();
  //   Directory? extenalStorageDir = await getExternalStorageDirectory();
  //   return downloadDir;
  // }
  saveImageToFolder(String url, Directory dir) {
    //
  }

  @override
  Widget build(BuildContext context) {
    var parameters = Get.parameters;
    String imageUrl = parameters['url']!;
    String id = parameters['id']!;
    return Scaffold(
      // color: Colors.transparent,
      appBar: null,
      body: ExtendedImageSlidePage(
        child: Center(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String fileName = "$id.png";
          if (Platform.isAndroid) {
            // downloadDir = await getExternalStorageDirectory();
            Uint8List? data =
                await getNetworkImageData(imageUrl, useCache: true);
            if (data != null) {
              await ImageGallerySaver.saveImage(data);
            }
          } else if (Platform.isMacOS ||
              Platform.isLinux ||
              Platform.isWindows) {
            Directory? downloadDir = await getDownloadsDirectory();
            if (downloadDir != null) {
              // print("download dir: $downloadDir");
              logger.d("download dir: $downloadDir");

              FileSaveLocation? result =
                  await getSaveLocation(suggestedName: fileName);
              if (result != null) {
                logger.d("file save location: $result");
                logger.d(result.path);
                var localFile = File(result.path);
                // final http
                Uint8List? data =
                    await getNetworkImageData(imageUrl, useCache: true);
                if (data != null) {
                  localFile.writeAsBytes(data);
                }
              }
            }
          }
        },
        child: const Icon(Icons.save_alt_rounded),
      ),
    );
  }
}

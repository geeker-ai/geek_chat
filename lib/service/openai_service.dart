import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class SSEClient {
  static final http.Client _client = http.Client();

  static Stream<String> subscribeToSSE(
      {required String url,
      required Map<String, String> headers,
      required Map<String, dynamic>? body}) {
    //
    StreamController<String> streamController = StreamController();
    try {
      var request = http.Request('POST', Uri.parse(url));
      headers.forEach((key, value) {
        request.headers[key] = value;
      });
      request.body = jsonEncode(body);
      Future<http.StreamedResponse> response = _client.send(request);
      // response.then((value) => value.stream.listen((data) {
      //       //
      //       // var data = utf8.decode(value);
      //       // print(utf8.decode(data));
      //       // print("-------");
      //       String line = utf8.decode(data);
      //       print(line);
      //       if (line.isNotEmpty) {
      //         line = line.replaceFirst('data:', '').trim();
      //         streamController.add(line);
      //       }
      //     }));
      response.asStream().listen((data) {
        data.stream
            .transform(const Utf8Decoder())
            .transform(const LineSplitter())
            .listen((dataLine) {
          if (dataLine.isEmpty) {
            // streamController.add('');
          } else {
            String value = dataLine.replaceFirst('data:', '').trim();
            streamController.add(value);
          }
        }, onError: (e, s) {
          streamController.addError(e, s);
        });
      }, onError: (e, s) {
        streamController.addError(e, s);
      });
    } catch (e, s) {
      streamController.addError(e, s);
    }
    return streamController.stream;
  }
}

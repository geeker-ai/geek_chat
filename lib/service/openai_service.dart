import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart' as rx;

class SSEClient {
  static final http.Client _client = http.Client();

  static Stream<String> subscribeToSSE(
      {required String url,
      required Map<String, String> headers,
      required Map<String, dynamic>? body,
      Duration debounce = const Duration(milliseconds: 10)}) {
    StreamController<String> streamController = StreamController();
    try {
      var request = http.Request('POST', Uri.parse(url));

      headers.forEach((key, value) {
        request.headers[key] = value;
      });

      request.body = jsonEncode(body);

      Future<http.StreamedResponse> response = _client.send(request);

      response.then((value) {
        value.stream
            // .toStringStream()
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .asyncExpand((event) => rx.Rx.timer(event, debounce))
            .listen(
          (event) {
            if (event.isNotEmpty) {
              String value = event.replaceFirst('data:', '').trim();
              streamController.add(value);
            }
          },
          onError: (e, s) {
            streamController.addError(e, s);
          },
          onDone: () {
            streamController.done;
            streamController.close();
          },
        );
      }, onError: (e, s) {
        streamController.addError(e, s);
      });
    } catch (e, s) {
      streamController.addError(e, s);
    }
    return streamController.stream;
  }
}

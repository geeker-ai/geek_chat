import 'dart:convert';

import 'package:dio/dio.dart';

class HttpClientService {
  static final _dio = Dio();

  static Future<String> getVersion(String url) async {
    Response response = await get(url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.toString());
      return json['version'];
    }
    return '';
  }

  static Future<Response> get(String url, {Map<String, String>? headers}) {
    Options? options;
    if (headers != null) {
      options = Options(headers: headers);
    }
    return _dio.get(url, options: options);
  }
}

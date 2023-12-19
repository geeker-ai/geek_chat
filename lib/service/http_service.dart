import 'dart:convert';

import 'package:dio/dio.dart';

class HttpClientService {
  static final _dio = Dio();

  static Future<String> activeLicense(
      String url, String license, String uuid, String lang) async {
    dynamic json = {
      "license": license,
      "uuid": uuid,
      "lang": lang,
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    Response response = await post(url, json: json, headers: headers);
    if (response.statusCode == 200) {
      return response.toString();
    }
    return '{}';
  }

  static Future<String> getReleaseInfo(String url) async {
    Response response = await get(url);
    if (response.statusCode == 200) {
      // var json = jsonDecode(response.toString());
      return response.toString();
    }
    return '';
  }

  static Future<String> getPrompts(
      String url, Map<String, String> headers) async {
    Response response = await get(url, headers: headers);
    if (response.statusCode == 200) {
      return response.toString();
    } else {
      return '';
    }
  }

  static Future<Response> postData(String url,
      {required Object data, required Map<String, String> headers}) {
    Options options =
        Options(headers: headers, responseType: ResponseType.json);
    return _dio.post(url, options: options, data: data);
  }

  static Future<Response> post(String url,
      {required dynamic json, Map<String, String>? headers}) {
    Options? options;
    if (headers != null) {
      options = Options(headers: headers, responseType: ResponseType.json);
    }
    return _dio.post(url, options: options, data: jsonEncode(json));
  }

  static Future<Response> get(String url, {Map<String, String>? headers}) {
    Options? options;
    if (headers != null) {
      options = Options(headers: headers, responseType: ResponseType.plain);
    }
    return _dio.get(url, options: options);
  }
}

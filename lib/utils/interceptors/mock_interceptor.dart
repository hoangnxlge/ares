import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:dio/dio.dart';

class MockInterceptor extends Interceptor {
  static const _jsonDir = 'assets/json';
  static const _jsonExtension = '.json';
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final resourcePath = _jsonDir + options.path + _jsonExtension;
    final data = jsonDecode(await rootBundle.loadString(resourcePath));
    await Future.delayed(const Duration(seconds: 1));
    handler.resolve(
      Response(
        data: data,
        requestOptions: options,
      ),
    );
  }
}

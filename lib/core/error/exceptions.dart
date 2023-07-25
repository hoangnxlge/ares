import 'package:dio/dio.dart';

class ServerException implements Exception {
  final String message;
  final int statusCode;

  ServerException(this.message, this.statusCode);

  ServerException.fromDioError(DioError dioError)
      : message =
            dioError.response?.statusMessage ?? dioError.message ?? 'DioError',
        statusCode = dioError.response?.statusCode ?? -1;

  @override
  String toString() {
    return 'ServerException: $message ($statusCode)';
  }
}

class LocalException implements Exception {
  final String message;

  LocalException(this.message);

  @override
  String toString() {
    return 'LocalException: $message';
  }
}

import 'package:dio/dio.dart';

import '../error/exceptions.dart';

abstract class RemoteDataSource {
  Future<T> safeCall<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on DioError catch (e) {
      throw ServerException.fromDioError(e);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

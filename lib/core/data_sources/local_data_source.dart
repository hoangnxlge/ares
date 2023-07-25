import '../error/exceptions.dart';

abstract class LocalDataSource {
  Future<T> safeCall<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (e) {
      throw LocalException(e.toString());
    }
  }
}

import 'package:dartz/dartz.dart';

import '../error/exceptions.dart';
import '../error/failures.dart';

abstract class BaseRepository {
  Future<Either<Failure, T>> safeCall<T>(
    Future<T> Function() operation,
  ) async {
    try {
      final result = await operation();
      return right(result);
    } on ServerException catch (e) {
      return left(ServerFailure.fromException(e));
    } on LocalException catch (e) {
      return left(LocalFailure(e.message));
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }
}

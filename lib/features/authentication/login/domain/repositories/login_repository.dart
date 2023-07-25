import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/auth_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, AuthEntity>> login({
    required String username,
    required String password,
  });
  Future<Either<Failure, String>> getValidAccessToken();
  Future<Either<Failure, void>> logOut();
}

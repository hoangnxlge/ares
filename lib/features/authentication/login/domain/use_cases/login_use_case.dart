import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/use_cases/use_case.dart';
import '../entities/auth_entity.dart';
import '../repositories/login_repository.dart';

class LoginUseCase extends UseCase<AuthEntity, LoginParams> {
  final LoginRepository repo;
  LoginUseCase(this.repo);
  @override
  Future<Either<Failure, AuthEntity>> call(LoginParams params) => repo.login(
        username: params.username,
        password: params.password,
      );
}

class LoginParams extends Equatable {
  final String username, password;

  const LoginParams({
    required this.username,
    required this.password,
  });
  @override
  List<Object?> get props => [username, password];
}

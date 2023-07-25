import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/use_cases/use_case.dart';
import '../repositories/login_repository.dart';

class LogOutUseCase extends UseCase<void, NoParams> {
  final LoginRepository repo;
  LogOutUseCase(this.repo);
  @override
  Future<Either<Failure, void>> call(NoParams params) => repo.logOut();
}

import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/use_cases/use_case.dart';
import '../repositories/login_repository.dart';

class GetValidAccessTokenUseCase extends UseCase<String, NoParams> {
  final LoginRepository repo;
  GetValidAccessTokenUseCase(this.repo);
  @override
  Future<Either<Failure, String>> call(NoParams params) =>
      repo.getValidAccessToken();
}

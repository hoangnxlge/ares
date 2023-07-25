import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_cases/use_case.dart';
import '../entities/settings.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUseCase extends UseCase<Settings, NoParams> {
  final SettingsRepository repo;

  GetSettingsUseCase(this.repo);
  @override
  Future<Either<Failure, Settings>> call(NoParams params) => repo.getSettings();
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_cases/use_case.dart';
import '../entities/settings.dart';
import '../repositories/settings_repository.dart';

class SaveSettingsUseCase extends UseCase<void, SaveSettingsParams> {
  final SettingsRepository repo;

  SaveSettingsUseCase(this.repo);
  @override
  Future<Either<Failure, void>> call(params) =>
      repo.saveSettings(params.settings);
}

class SaveSettingsParams extends Equatable {
  final Settings settings;

  const SaveSettingsParams(this.settings);
  @override
  List<Object?> get props => [settings];
}

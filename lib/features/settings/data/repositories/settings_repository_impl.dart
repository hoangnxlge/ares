import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../domain/entities/settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../data_sources/settings_local_data_source.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl extends BaseRepository
    implements SettingsRepository {
  final SettingsLocalDataSource localSource;

  SettingsRepositoryImpl({required this.localSource});
  @override
  Future<Either<Failure, Settings>> getSettings() async {
    return safeCall(() async {
      final settingsModel = await localSource.getSettings();
      return settingsModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> saveSettings(Settings settings) async {
    return safeCall(
      () => localSource.saveSettings(SettingsModel.fromEntity(settings)),
    );
  }
}

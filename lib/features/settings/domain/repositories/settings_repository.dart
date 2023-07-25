import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, Settings>> getSettings();
  Future<Either<Failure, void>> saveSettings(Settings settings);
}

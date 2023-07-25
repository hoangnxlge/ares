import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ares/core/error/exceptions.dart';
import 'package:ares/core/error/failures.dart';
import 'package:ares/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:ares/features/settings/data/models/settings_model.dart';
import 'package:ares/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:ares/features/settings/domain/entities/settings.dart';

import 'setting_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SettingsLocalDataSource>()])
void main() {
  late MockSettingsLocalDataSource localSource;
  late SettingsRepositoryImpl repo;
  setUp(() {
    localSource = MockSettingsLocalDataSource();
    repo = SettingsRepositoryImpl(localSource: localSource);
  });

  const tSettingsModel = SettingsModel();
  const tSettings = Settings();

  group('GetSettings', () {
    test('should return settings entity from localData source', () async {
      when(localSource.getSettings()).thenAnswer((_) async => tSettingsModel);
      final settings = await repo.getSettings();
      verify(localSource.getSettings());
      expect(settings, right(tSettings));
    });
    test('should throw LocalFalure when there is some error', () async {
      when(localSource.getSettings()).thenThrow(LocalException(''));
      final call = await repo.getSettings();
      expect(call, left(LocalFailure('')));
    });
  });
  group('SaveSettings', () {
    test('should save settings to local database', () async {
      when(localSource.saveSettings(any)).thenAnswer(Future.value);
      await repo.saveSettings(tSettings);
      verify(localSource.saveSettings(tSettingsModel));
    });
    test('should throw LocalFailure when there is some error', () async {
      when(localSource.saveSettings(any)).thenThrow(LocalException(''));
      final call = await repo.saveSettings(tSettings);
      expect(call, left(LocalFailure('')));
    });
  });
}

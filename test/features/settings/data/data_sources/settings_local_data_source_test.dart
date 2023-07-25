import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ares/core/error/exceptions.dart';
import 'package:ares/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:ares/features/settings/data/models/settings_model.dart';

import 'settings_local_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Box>()])
void main() {
  late SettingsLocalDataSourceImpl localSource;
  late MockBox box;
  const tSettingsModel = SettingsModel(isDarkTheme: false);
  setUp(() {
    box = MockBox();
    localSource = SettingsLocalDataSourceImpl(box);
  });
  group('getSettings', () {
    test(
        'should return settingsModel when there is cached settingsModel in database',
        () async {
      when(box.get(any)).thenAnswer((_) async => tSettingsModel);
      final settingsModel = await localSource.getSettings();
      verify(box.get(SettingsKey.settings.name));
      expect(settingsModel, tSettingsModel);
    });
    test('''should return a new settingsModel and save to database when there is
         no cached settingsModel''', () async {
      when(box.get(any)).thenAnswer((_) async => null);
      final settingsModel = await localSource.getSettings();
      verify(box.get(SettingsKey.settings.name));
      verify(box.put(SettingsKey.settings.name, const SettingsModel()));
      expect(settingsModel, const SettingsModel());
    });
    test('should throw LocalException when there is some error', () async {
      when(box.get(any)).thenThrow(() async => LocalException(''));
      final call = localSource.getSettings();
      expect(call, throwsA(const TypeMatcher<LocalException>()));
    });
  });

  group('saveSettings', () {
    test('should save settings to local database', () async {
      localSource.saveSettings(tSettingsModel);
      verify(box.put(SettingsKey.settings.name, tSettingsModel));
    });
    test('should throw LocalException when there is some error', () async {
      when(box.put(any, any)).thenThrow(Future.value(LocalException('')));
      final call = localSource.saveSettings(tSettingsModel);
      expect(call, throwsA(const TypeMatcher<LocalException>()));
    });
  });
}
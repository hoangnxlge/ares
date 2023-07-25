import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ares/features/settings/domain/entities/settings.dart';
import 'package:ares/features/settings/domain/repositories/settings_repository.dart';
import 'package:ares/features/settings/domain/use_cases/save_settings_use_case.dart';

import 'save_settings_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SettingsRepository>()])
void main() {
  late MockSettingsRepository repo;
  late SaveSettingsUseCase useCase;
  const tSettings = Settings(isDarkTheme: false);
  setUp(() {
    repo = MockSettingsRepository();
    useCase = SaveSettingsUseCase(repo);
  });

  group('SaveSettingsUseCase', () {
    test('should call saveSettings from repo', () {
      useCase(const SaveSettingsParams(tSettings));
      verify(repo.saveSettings(tSettings));
    });
  });
}

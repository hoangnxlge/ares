import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ares/core/use_cases/use_case.dart';
import 'package:ares/features/settings/domain/repositories/settings_repository.dart';
import 'package:ares/features/settings/domain/use_cases/get_settings_use_case.dart';

import 'get_settings_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SettingsRepository>()])
void main() {
  late MockSettingsRepository repo;
  late GetSettingsUseCase useCase;
  setUp(() {
    repo = MockSettingsRepository();
    useCase = GetSettingsUseCase(repo);
  });

  group('GetSettingsUseCase', () {
    test('Should call getSettings function from repo', () {
      useCase(NoParams());
      verify(repo.getSettings());
    });
  });
}

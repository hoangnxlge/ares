import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ares/core/use_cases/use_case.dart';
import 'package:ares/features/settings/domain/entities/settings.dart';
import 'package:ares/features/settings/settings_exports.dart';

import 'settings_bloc_test.mocks.dart';

@GenerateNiceMocks(
  [MockSpec<GetSettingsUseCase>(), MockSpec<SaveSettingsUseCase>()],
)
void main() {
  late MockGetSettingsUseCase getSettingsUseCase;
  late MockSaveSettingsUseCase saveSettingsUseCase;
  late SettingsBloc bloc;
  const tSettings = Settings();
  setUp(() {
    getSettingsUseCase = MockGetSettingsUseCase();
    saveSettingsUseCase = MockSaveSettingsUseCase();
    bloc = SettingsBloc(
      getSettingsUseCase: getSettingsUseCase,
      saveSettingsUseCase: saveSettingsUseCase,
    );
    when(getSettingsUseCase(any)).thenAnswer((_) async => right(tSettings));
    when(saveSettingsUseCase(any)).thenAnswer((_) async => right(null));
  });
  group('Settings bloc', () {
    blocTest<SettingsBloc, SettingsState>(
      'emits [GetSettingSuccess] state when [GetSettingsEvent] is added.',
      build: () => bloc,
      act: (bloc) => bloc.add(const SettingsEvent.getSettings()),
      expect: () => [
        const SettingsState.loading(),
        const SettingsState.getSettingsSuccess(tSettings),
      ],
      verify: (bloc) {
        verify(getSettingsUseCase(NoParams()));
        verifyZeroInteractions(saveSettingsUseCase);
      },
    );
  });
}

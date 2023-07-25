part of 'settings_bloc.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.initial() = _Initial;
  const factory SettingsState.getSettingsSuccess(Settings settings) =
      _GetSettingsSuccess;
  const factory SettingsState.saveSettingsSuccess() = _SaveSettingsSuccess;
  const factory SettingsState.loading() = _Loading;
  const factory SettingsState.error(String err) = _Error;
}

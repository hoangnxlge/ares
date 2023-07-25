part of 'settings_bloc.dart';

@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.started() = _Started;
  const factory SettingsEvent.getSettings() = _GetSettings;
  const factory SettingsEvent.saveSettings(Settings settings) = _SaveSettings;
}

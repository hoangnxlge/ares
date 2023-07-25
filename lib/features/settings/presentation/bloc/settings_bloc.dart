import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/use_cases/use_case.dart';
import '../../domain/entities/settings.dart';
import '../../domain/use_cases/get_settings_use_case.dart';
import '../../domain/use_cases/save_settings_use_case.dart';

part 'settings_bloc.freezed.dart';
part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final SaveSettingsUseCase saveSettingsUseCase;
  SettingsBloc({
    required this.getSettingsUseCase,
    required this.saveSettingsUseCase,
  }) : super(const _Initial()) {
    on<_GetSettings>(_getSettings);
    on<_SaveSettings>(_saveSettings);
  }

  FutureOr<void> _getSettings(
      _GetSettings event, Emitter<SettingsState> emit) async {
    emit(const _Loading());
    final result = await getSettingsUseCase(NoParams());
    result.fold(
      (failure) => emit(_Error(failure.toString())),
      (settings) => emit(_GetSettingsSuccess(settings)),
    );
  }

  FutureOr<void> _saveSettings(
      _SaveSettings event, Emitter<SettingsState> emit) async {
    emit(const _Loading());
    final result =
        await saveSettingsUseCase(SaveSettingsParams(event.settings));
    result.fold(
      (failure) => emit(_Error(failure.toString())),
      (_) {
        emit(const _SaveSettingsSuccess());
        emit(_GetSettingsSuccess(event.settings));
      },
    );
  }
}

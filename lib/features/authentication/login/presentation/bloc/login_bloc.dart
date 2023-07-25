import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/use_cases/login_use_case.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  LoginBloc({required this.loginUseCase}) : super(const _Initial()) {
    on<_Login>(_onLogin);
  }

  Future<FutureOr<void>> _onLogin(
      _Login event, Emitter<LoginState> emit) async {
    emit(const _Loading());
    final result = await loginUseCase(
      LoginParams(
        username: event.username,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(_Error(failure.toString())),
      (_) => emit(const _Success()),
    );
  }
}

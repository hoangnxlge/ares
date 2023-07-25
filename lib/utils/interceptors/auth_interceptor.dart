import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../core/use_cases/use_case.dart';
import '../../features/authentication/login/domain/use_cases/get_valid_access_token_use_case.dart';
import '../../features/authentication/login/domain/use_cases/log_out_use_case.dart';
import '../navigator/app_routing.dart';
import '../navigator/navigator_utils.dart';

class AuthInterceptor extends Interceptor {
  final GetValidAccessTokenUseCase getValidAccessTokenUseCase;
  final LogOutUseCase logOutUseCase;

  AuthInterceptor({
    required this.getValidAccessTokenUseCase,
    required this.logOutUseCase,
  });
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final tokenEither = await getValidAccessTokenUseCase(NoParams());
    tokenEither.fold(
      (_) async {
        Navigator.of(NavigatorUtils.context).pushNamedAndRemoveUntil(
          Routes.loginPage.name,
          (route) => false,
        );
        await logOutUseCase(NoParams());
      },
      (token) {
        options.headers.addAll({
          'Authorization': 'Bearer $token',
        });
        handler.next(options);
      },
    );
  }
}

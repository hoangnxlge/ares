import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:retrofit/retrofit.dart';

import '../models/auth_model.dart';
import '../models/login_request_model.dart';

part 'login_client.g.dart';

@RestApi()
abstract class LoginClient {
  factory LoginClient(Dio dio, {String? baseUrl}) = _LoginClient;

  @POST('/login')
  Future<AuthModel> login(@Body() LoginRequestModel loginRequestModel);

  @POST('/refresh_token')
  Future<AuthModel> refreshToken({
    @JsonKey(name: 'refresh_token') @Body() required String refreshToken,
  });
}

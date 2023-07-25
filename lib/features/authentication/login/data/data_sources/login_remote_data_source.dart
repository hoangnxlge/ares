import '../../../../../core/data_sources/remote_data_source.dart';
import '../models/auth_model.dart';
import '../models/login_request_model.dart';
import 'login_client.dart';

abstract class LoginRemoteDataSource {
  Future<AuthModel> login({
    required String username,
    required String password,
  });
  Future<AuthModel> refreshToken(String refreshToken);
}

class LoginRemoteDataSourceImpl extends RemoteDataSource
    implements LoginRemoteDataSource {
  final LoginClient client;

  LoginRemoteDataSourceImpl(this.client);
  @override
  Future<AuthModel> login({
    required String username,
    required String password,
  }) async {
    return safeCall(
      () => client.login(
        LoginRequestModel(
          username: username,
          password: password,
        ),
      ),
    );
  }

  @override
  Future<AuthModel> refreshToken(String refreshToken) async {
    return safeCall(() => client.refreshToken(refreshToken: refreshToken));
  }
}

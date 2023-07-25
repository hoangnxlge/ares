import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../core/data_sources/local_data_source.dart';
import '../models/auth_model.dart';

enum LoginKeys { accessToken, refreshToken, isLogedIn }

abstract class LoginLocalDataSource {
  Future<void> saveTokens(AuthModel authModel);
  Future<void> clearTokens();
  Future<bool> get isLogedIn;
  Future<String> get accessToken;
  Future<String> get refreshToken;
}

class LoginLocalDataSourceImpl extends LocalDataSource
    implements LoginLocalDataSource {
  final Box box;

  LoginLocalDataSourceImpl(this.box);
  @override
  Future<void> saveTokens(AuthModel authModel) async {
    return safeCall(
      () => box.putAll({
        LoginKeys.accessToken.name: authModel.accessToken,
        LoginKeys.refreshToken.name: authModel.refreshToken,
        LoginKeys.isLogedIn.name: true,
      }),
    );
  }

  @override
  Future<String> get accessToken {
    return safeCall(
      () => box.get(
        LoginKeys.accessToken.name,
        defaultValue: '',
      ),
    );
  }

  @override
  Future<String> get refreshToken {
    return safeCall(
      () => box.get(
        LoginKeys.refreshToken.name,
        defaultValue: '',
      ),
    );
  }

  @override
  Future<void> clearTokens() {
    return safeCall(
      () => box.deleteAll([
        LoginKeys.accessToken.name,
        LoginKeys.refreshToken.name,
        LoginKeys.isLogedIn.name,
      ]),
    );
  }

  @override
  Future<bool> get isLogedIn {
    return safeCall(
      () => box.get(
        LoginKeys.isLogedIn.name,
        defaultValue: false,
      ),
    );
  }
}

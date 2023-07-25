import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/repositories/base_repository.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../data_sources/login_local_data_source.dart';
import '../data_sources/login_remote_data_source.dart';

class LoginRepositoryImpl extends BaseRepository implements LoginRepository {
  final LoginRemoteDataSource remoteSource;
  final LoginLocalDataSource localSource;

  LoginRepositoryImpl({
    required this.remoteSource,
    required this.localSource,
  });

  bool _isTokenValid(String token) {
    if ([null, ''].contains(token)) return false;
    final tokenJson = jsonDecode(utf8.decode(base64Decode(token)));
    final expString = tokenJson['exp'];
    final expDate = DateTime.fromMillisecondsSinceEpoch(expString ?? 0 * 1000);
    return expDate.isAfter(DateTime.now());
  }

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String username,
    required String password,
  }) async {
    return safeCall(() async {
      final authModel = await remoteSource.login(
        username: username,
        password: password,
      );
      await localSource.saveTokens(authModel);
      return authModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, String>> getValidAccessToken() {
    return safeCall(
      () async {
        final token = await localSource.accessToken;
        if (_isTokenValid(token)) return token;
        final refreshToken = await localSource.refreshToken;
        if (_isTokenValid(token)) {
          final authModel = await remoteSource.refreshToken(refreshToken);
          await localSource.saveTokens(authModel);
          final accessToken = await localSource.accessToken;
          return accessToken;
        }
        throw Exception();
      },
    );
  }

  @override
  Future<Either<Failure, void>> logOut() => safeCall(localSource.clearTokens);
}

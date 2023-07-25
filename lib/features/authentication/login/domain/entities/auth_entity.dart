import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String accessToken, refreshToken;

  const AuthEntity({
    this.accessToken = '',
    this.refreshToken = '',
  });

  @override
  List<Object?> get props => [accessToken, refreshToken];
}

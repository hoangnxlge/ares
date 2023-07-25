import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/auth_entity.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@freezed
class AuthModel with _$AuthModel {
  const AuthModel._();
  @HiveType(typeId: 2)
  const factory AuthModel({
    @HiveField(0)
    @JsonKey(name: 'access_token')
    @Default('')
        String accessToken,
    @HiveField(1)
    @JsonKey(name: 'refresh_token')
    @Default('')
        String refreshToken,
  }) = _AuthModel;
  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);
  factory AuthModel.fromEntity(AuthEntity entity) => AuthModel(
        accessToken: entity.accessToken,
        refreshToken: entity.refreshToken,
      );
  AuthEntity toEntity() => AuthEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
}

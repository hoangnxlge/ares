import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/settings.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@freezed
class SettingsModel with _$SettingsModel {
  const SettingsModel._();
  @HiveType(typeId: 0)
  const factory SettingsModel({
    @HiveField(0) @Default(false) final bool isDarkTheme,
    @HiveField(1) @Default('en') final String languageCode,
  }) = _SettingsModel;
  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
  factory SettingsModel.fromEntity(Settings entity) => SettingsModel(
        isDarkTheme: entity.isDarkTheme,
        languageCode: entity.languageCode,
      );
  Settings toEntity() => Settings(
        isDarkTheme: isDarkTheme,
        languageCode: languageCode,
      );
}

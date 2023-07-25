import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/settings_model.dart';

enum SettingsKey { settings }

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettings();
  Future<void> saveSettings(SettingsModel settingsModel);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final Box box;

  SettingsLocalDataSourceImpl(this.box);
  @override
  Future<SettingsModel> getSettings() async {
    try {
      SettingsModel? settingsModel = await box.get(SettingsKey.settings.name);
      if (settingsModel != null) {
        return settingsModel;
      } else {
        settingsModel = const SettingsModel();
        box.put(SettingsKey.settings.name, settingsModel);
        return settingsModel;
      }
    } catch (e) {
      throw LocalException(e.toString());
    }
  }

  @override
  Future<void> saveSettings(SettingsModel settingsModel) async {
    try {
      await box.put(SettingsKey.settings.name, settingsModel);
    } catch (e) {
      throw LocalException(e.toString());
    }
  }
}

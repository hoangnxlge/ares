import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_flavors.dart';

class AppConfig {
  final String baseUrl;
  final String appName;
  final AppFlavor flavor;
  final bool useMock;

  AppConfig({
    required this.appName,
    required this.baseUrl,
    required this.flavor,
    this.useMock = false,
  });

  static Future<AppConfig> dev() async {
    await dotenv.load(fileName: 'env/.env.development');
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final useMock = dotenv.env['USE_MOCK'] == 'true';
    return AppConfig(
      appName: 'Ares develop',
      baseUrl: baseUrl,
      flavor: AppFlavor.develop,
      useMock: useMock,
    );
  }

  static Future<AppConfig> staging() async {
    await dotenv.load(fileName: 'env/.env.staging');
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    return AppConfig(
      appName: 'Ares staging',
      baseUrl: baseUrl,
      flavor: AppFlavor.staging,
    );
  }

  static Future<AppConfig> prod() async {
    await dotenv.load(fileName: 'env/.env.prod');
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    return AppConfig(
      appName: 'Ares production',
      baseUrl: baseUrl,
      flavor: AppFlavor.production,
    );
  }
}

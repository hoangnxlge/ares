import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../config/app_config.dart';
import '../../config/app_flavors.dart';
import '../../core/network/network_info.dart';
import '../../features/authentication/login/login_exports.dart';
import '../../features/settings/settings_exports.dart';
import '../interceptors/mock_interceptor.dart';

final getIt = GetIt.instance;
Future<void> init() async {
  // core
  _regisCore();

  // features
  _regisSettingsFeature();
  _regisLoginFeature();

  // others
  await Future.wait([
    _regisConfig(),
    _regisExternal(),
  ]);
}

void _regisCore() {
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<InternetConnectionChecker>()),
  );
}

Future<void> _regisConfig() async {
  late AppFlavor flavor;
  late AppConfig appConfig;
  const flavorString =
      String.fromEnvironment('flavor', defaultValue: 'develop');
  for (var fl in AppFlavor.values) {
    if (fl.name.contains(flavorString)) {
      flavor = fl;
    }
  }
  switch (flavor) {
    case AppFlavor.develop:
      appConfig = await AppConfig.dev();
      break;
    case AppFlavor.staging:
      appConfig = await AppConfig.staging();
      break;
    case AppFlavor.production:
      appConfig = await AppConfig.prod();
      break;
  }
  getIt.registerSingleton<AppConfig>(appConfig);
}

Future<void> _regisExternal() async {
  getIt.registerLazySingleton(() => InternetConnectionChecker());
  getIt.registerLazySingleton(
    () {
      final appConfig = getIt<AppConfig>();
      final dio = Dio(
        BaseOptions(
          baseUrl: appConfig.baseUrl,
          connectTimeout: const Duration(seconds: 5),
        ),
      );
      dio.interceptors.addAll([
        if (appConfig.useMock) ...[MockInterceptor()]
      ]);
      return dio;
    },
  );
  await Hive.initFlutter();
  final box = await Hive.openBox('appBox');
  getIt.registerSingleton<Box>(box);
}

void _regisSettingsFeature() {
// use cases
  getIt.registerLazySingleton(() => GetSettingsUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveSettingsUseCase(getIt()));

// repositories
  getIt.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(localSource: getIt()));

// data sources
  getIt.registerLazySingleton<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(getIt()));

// models adapter
  Hive.registerAdapter(SettingsModelAdapter());
}

void _regisLoginFeature() {
// use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));

// repositories
  getIt.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(
        localSource: getIt(),
        remoteSource: getIt(),
      ));

// data sources
  getIt.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(getIt<LoginClient>()),
  );
  getIt.registerLazySingleton<LoginClient>(() => LoginClient(getIt()));
  getIt.registerLazySingleton<LoginLocalDataSource>(
      () => LoginLocalDataSourceImpl(getIt()));

// models adapter
  Hive.registerAdapter(AuthModelAdapter());
}

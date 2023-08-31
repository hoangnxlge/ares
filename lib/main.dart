import 'package:ares/features/luna_api/presentaion/luna_api_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'config/app_config.dart';
import 'features/settings/data/data_sources/settings_local_data_source.dart';
import 'features/settings/data/models/settings_model.dart';
import 'shared/themes/app_themes.dart';
import 'utils/di/injections.dart';
import 'utils/di/injections.dart' as injections;
import 'utils/navigator/app_routing.dart';
import 'utils/navigator/navigator_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await injections.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('vi', 'VN'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: ValueListenableBuilder<Box>(
        valueListenable:
            getIt<Box>().listenable(keys: [SettingsKey.settings.name]),
        builder: (context, box, child) {
          final settingsModel =
              (box.get(SettingsKey.settings.name) as SettingsModel?) ??
                  const SettingsModel();
          return MaterialApp(
            navigatorKey: NavigatorUtils.key,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: getIt<AppConfig>().appName,
            theme: AppThemes.light,
            darkTheme: AppThemes.dark,
            themeMode:
                settingsModel.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            onGenerateRoute: AppRouting.onGenerateRoute,
            initialRoute: Routes.basePage.name,
          );
        },
      ),
    );
  }
}

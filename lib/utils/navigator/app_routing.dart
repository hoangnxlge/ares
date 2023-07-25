import 'package:flutter/material.dart';

import '../../features/apps/presentations/pages/apps_page.dart';
import '../../features/authentication/login/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

enum Routes { homePage, loginPage, settingsPage, appsPage }

abstract class AppRouting {
  static Route onGenerateRoute(RouteSettings settings) {
    final routes = {
      Routes.homePage.name: (_) => const HomePage(),
      Routes.settingsPage.name: (_) => SettingsRoute.route,
      Routes.loginPage.name: (_) => LoginRoute.route,
      Routes.appsPage.name: (_) => AppsRoute.route,
    };
    return MaterialPageRoute(
      builder: routes[settings.name]!,
      settings: settings,
    );
  }
}

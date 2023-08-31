import 'package:ares/features/base/presentation/base_page.dart';
import 'package:ares/features/luna_api/presentaion/luna_api_page.dart';
import 'package:flutter/material.dart';

import '../../features/apps/presentations/pages/apps_page.dart';
import '../../features/authentication/login/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

enum Routes {
  homePage,
  loginPage,
  settingsPage,
  appsPage,
  lunaApiPage,
  basePage,
}

abstract class AppRouting {
  static Route onGenerateRoute(RouteSettings settings) {
    final routes = {
      Routes.homePage.name: (_) => const HomePage(),
      Routes.settingsPage.name: (_) => SettingsRoute.route,
      Routes.loginPage.name: (_) => LoginRoute.route,
      Routes.appsPage.name: (_) => AppsRoute.route,
      Routes.appsPage.name: (_) => AppsRoute.route,
      Routes.lunaApiPage.name: (_) => LunaApiRoute.route,
      Routes.basePage.name: (_) => BaseRoute.route,
    };
    return MaterialPageRoute(
      builder: routes[settings.name]!,
      settings: settings,
    );
  }
}

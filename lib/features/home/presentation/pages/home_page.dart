import 'package:ares/features/apps/presentations/pages/apps_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../config/app_config.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../utils/di/injections.dart';
import '../../../../utils/responsive/device_info.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageController = PageController();
  int currentPageIndex = 0;
  List<BottomNavigationBarItem> get navItems => [
        BottomNavigationBarItem(
          label: LocaleKeys.home.tr(),
          icon: const Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: LocaleKeys.settings.tr(),
          icon: const Icon(Icons.settings),
        )
      ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void changePage(int index) {
    setState(() {
      currentPageIndex = index;
      pageController.jumpToPage(currentPageIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getIt<AppConfig>().appName)),
      bottomNavigationBar: Visibility(
        visible: DeviceInfo.isMobile,
        child: BottomNavigationBar(
          key: ValueKey(context.locale),
          items: navItems
              .map((item) => BottomNavigationBarItem(
                    icon: item.icon,
                    label: item.label,
                  ))
              .toList(),
          currentIndex: currentPageIndex,
          onTap: changePage,
        ),
      ),
      body: SafeArea(
        child: Row(
          children: [
            Visibility(
              visible: DeviceInfo.isTablet,
              child: NavigationRail(
                destinations: navItems
                    .map((item) => NavigationRailDestination(
                          icon: item.icon,
                          label: Text(item.label ?? ''),
                        ))
                    .toList(),
                selectedIndex: currentPageIndex,
                onDestinationSelected: changePage,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: [
                    const AppsPage(),
                    SettingsRoute.route,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

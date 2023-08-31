import 'package:ares/features/apps/presentations/pages/apps_page.dart';
import 'package:ares/features/luna_api/presentaion/luna_api_page.dart';
import 'package:flutter/material.dart';

class BaseRoute {
  static Widget get route => const BasePage();
}

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final pageController = PageController();
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: NavigationDrawer(
        onDestinationSelected: (index) {
          setState(() {
            pageController.jumpToPage(index);
          });
          Navigator.pop(context);
        },
        selectedIndex:
            pageController.hasClients ? pageController.page?.toInt() : 0,
        children: [
          const DrawerHeader(child: Text('Ares')),
          ...[
            (Icons.api, 'Luna Api Testing'),
            (Icons.apps, 'Apps'),
          ].map(
            (e) => NavigationDrawerDestination(
              icon: Icon(e.$1),
              label: Text(e.$2),
            ),
          )
        ],
      ),
      body: PageView(
        controller: pageController,
        children: [
          LunaApiRoute.route,
          AppsRoute.route,
        ],
      ),
    );
  }
}

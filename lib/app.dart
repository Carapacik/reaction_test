import 'package:flutter/material.dart';
import 'package:reactiontest/main_page/main_view.dart';
import 'package:reactiontest/settings_page/settings_controller.dart';
import 'package:reactiontest/settings_page/settings_view.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          onGenerateTitle: (BuildContext context) => "Reaction Test",
          theme: ThemeData().copyWith(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleTextStyle: TextStyle(color: Color(0xFF2E2E2E)),
              iconTheme: IconThemeData(color: Color(0xFF2E2E2E)),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleTextStyle: TextStyle(color: Color(0xFFDFDFDF)),
              iconTheme: IconThemeData(color: Color(0xFFDFDFDF)),
            ),
          ),
          themeMode: settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case MainView.routeName:
                  default:
                    return const MainView();
                }
              },
            );
          },
        );
      },
    );
  }
}

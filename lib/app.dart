import 'package:flutter/material.dart';
import 'package:reactiontest/main_page/main_view.dart';
import 'package:reactiontest/settings_page/settings_controller.dart';
import 'package:reactiontest/settings_page/settings_view.dart';

class App extends StatelessWidget {
  const App({
    required this.settingsController,
    Key? key,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: settingsController,
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          onGenerateTitle: (context) => 'Reaction Test',
          theme: ThemeData.light().copyWith(
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
          onGenerateRoute: (routeSettings) => MaterialPageRoute<void>(
            settings: routeSettings,
            builder: (context) {
              switch (routeSettings.name) {
                case SettingsView.routeName:
                  return SettingsView(controller: settingsController);
                case MainView.routeName:
                default:
                  return const MainView();
              }
            },
          ),
        ),
      );
}

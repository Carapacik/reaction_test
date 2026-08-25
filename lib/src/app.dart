import 'package:material_ui/material_ui.dart';
import 'package:reactiontest/src/reaction_test/reaction_test_view.dart';
import 'package:reactiontest/src/settings_page/settings_controller.dart';
import 'package:reactiontest/src/settings_page/settings_view.dart';

class const App({required final SettingsController settingsController, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: settingsController,
    builder: (context, _) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reaction Test',
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: settingsController.themeMode,
      home: const ReactionTestView(),
      routes: {SettingsView.routeName: (_) => SettingsView(controller: settingsController)},
    ),
  );

  ThemeData _theme(Brightness brightness) {
    const seedColor = Color(0xFFE02D47);
    final colorScheme = ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);
    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: const AppBarTheme(centerTitle: false, scrolledUnderElevation: 0),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
      ),
    );
  }
}

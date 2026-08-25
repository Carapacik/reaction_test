import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService(final SharedPreferencesAsync _sharedPreferencesAsync) {
  static const _key = 'theme';

  Future<ThemeMode> themeMode() async {
    final int? savedTheme = await _sharedPreferencesAsync.getInt(_key);
    return switch (savedTheme) {
      1 => ThemeMode.light,
      2 => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    await _sharedPreferencesAsync.setInt(_key, theme.index);
  }
}

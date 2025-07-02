import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  SettingsService(this._sharedPreferencesAsync);

  final SharedPreferencesAsync _sharedPreferencesAsync;
  static const _key = 'theme';

  Future<ThemeMode> themeMode() async {
    final themeMode = await _sharedPreferencesAsync.getInt(_key);
    return ThemeMode.values.elementAt(themeMode ?? 0);
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    await _sharedPreferencesAsync.setInt(_key, theme.index);
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _key = 'theme';

  Future<ThemeMode> themeMode() async {
    final sp = await SharedPreferences.getInstance();
    return ThemeMode.values.elementAt(sp.getInt(_key) ?? 0);
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_key, theme.index);
  }
}

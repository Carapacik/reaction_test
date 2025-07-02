import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactiontest/app.dart';
import 'package:reactiontest/settings_page/settings_controller.dart';
import 'package:reactiontest/settings_page/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final settingsController = SettingsController(SettingsService(SharedPreferencesAsync()));
  await settingsController.loadSettings();
  runApp(App(settingsController: settingsController));
}

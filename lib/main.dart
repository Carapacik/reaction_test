import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'ad_state.dart';
import 'app.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_service.dart';

void main() async {
  setPathUrlStrategy();
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final initFuture = MobileAds.instance.initialize();
  final ad = AdState(initFuture);
  runApp(
    Provider.value(
      value: ad,
      builder: (context, child) => App(settingsController: settingsController),
    ),
  );
}

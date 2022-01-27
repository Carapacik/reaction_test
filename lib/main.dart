import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:reactiontest/app.dart';
import 'package:reactiontest/main_page/ad_state.dart';
import 'package:reactiontest/settings_page/settings_controller.dart';
import 'package:reactiontest/settings_page/settings_service.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  await dotenv.load();
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

import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  AdState(this.initialization);

  Future<InitializationStatus> initialization;

  String? get adUnitId =>
      dotenv.env[Platform.isAndroid ? "ANDROID_ID" : "IOS_ID"];
}

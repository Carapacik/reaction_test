import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  String get adUnitId {
    final id = dotenv.env[Platform.isAndroid ? "ANDROID_ID" : "IOS_ID"];
    if (id?.isEmpty ?? false) {
      return id!;
    }
    return BannerAd.testAdUnitId;
  }
}

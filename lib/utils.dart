import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';

String? get adUnitId {
  return dotenv.env[Platform.isAndroid ? "ANDROID_ID" : "IOS_ID"];
}

Future<void> appearReview() async {
  if (kIsWeb) return;
  if (Platform.isAndroid || Platform.isIOS) {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }
}

Future<void> initAd() async {
  if (kIsWeb) return;
  if (Platform.isAndroid || Platform.isIOS) {
    await MobileAds.instance.initialize();
  }
}

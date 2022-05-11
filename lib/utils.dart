import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';

String _androidId = '';
String _iosId = '';

String? get adId => Platform.isAndroid ? _androidId : _iosId;

Future<void> appearReview() async {
  if (kIsWeb) {
    return;
  }
  if (Platform.isAndroid || Platform.isIOS) {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    }
  }
}

Future<void> initAd() async {
  if (kIsWeb) {
    return;
  }
  if (Platform.isAndroid || Platform.isIOS) {
    await MobileAds.instance.initialize();
  }
}

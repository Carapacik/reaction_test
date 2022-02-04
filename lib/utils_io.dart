import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';

Future<void> appearReview() async {
  final InAppReview inAppReview = InAppReview.instance;
  if (await inAppReview.isAvailable()) {
    inAppReview.requestReview();
  }
}

Future<void> initAd() async {
  if (Platform.isAndroid || Platform.isIOS) {
    MobileAds.instance.initialize();
  }
}

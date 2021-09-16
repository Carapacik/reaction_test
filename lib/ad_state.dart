import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  String get bannerAdUnitId => Platform.isAndroid ? "ca-app-pub-6023624871762142/6725081797" : "id for IOS";

  BannerAdListener get adListener => _adListener;

  final BannerAdListener _adListener = BannerAdListener(
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
    },
  );
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reactiontest/main_page/body.dart';
import 'package:reactiontest/settings_page/settings_view.dart';
import 'package:reactiontest/utils.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool _bannerAdIsLoaded = false;
  BannerAd? _bannerAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS) && adUnitId != null) {
      _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adUnitId!,
        listener: BannerAdListener(
          onAdLoaded: (ad) => setState(() => _bannerAdIsLoaded = true),
          onAdFailedToLoad: (ad, error) => ad.dispose(),
        ),
        request: const AdRequest(),
      )..load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: const Body(),
      bottomNavigationBar: SizedBox(
        height: AdSize.banner.height.toDouble(),
        width: AdSize.banner.width.toDouble(),
        child: _bannerAdIsLoaded && _bannerAd != null
            ? AdWidget(ad: _bannerAd!)
            : null,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    _bannerAdIsLoaded = false;
  }
}

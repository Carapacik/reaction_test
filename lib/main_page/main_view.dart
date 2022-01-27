import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:reactiontest/main_page/ad_state.dart';
import 'package:reactiontest/main_page/timer_state.dart';
import 'package:reactiontest/settings_page/settings_view.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  BannerAd? _bannerAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then(
      (status) {
        setState(
          () {
            _bannerAd = BannerAd(
              adUnitId: adState.adUnitId,
              size: AdSize.banner,
              request: const AdRequest(),
              listener: BannerAdListener(
                onAdFailedToLoad: (Ad ad, LoadAdError error) => ad.dispose(),
              ),
            )..load();
          },
        );
      },
    );
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
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: const _Timer(),
      bottomNavigationBar: _bannerAd != null
          ? SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              width: _bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _Timer extends StatefulWidget {
  const _Timer({Key? key}) : super(key: key);

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<_Timer> {
  TimerState _timerState = TimerState.readyToStart;
  String _millisecondsText = "";
  int _reviewCounter = 0;
  Timer? _waitingTimer;
  Timer? _stoppableTimer;
  final Shader _linearGradient = const LinearGradient(
    colors: [
      Color(0xFFE02D47),
      Color(0xFFBD37F5),
    ],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 250, 100));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Test your reaction speed",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              foreground: Paint()..shader = _linearGradient,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(color: Colors.black26),
            height: 150,
            alignment: Alignment.center,
            child: Text(
              _millisecondsText,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 200,
            height: 140,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _switchState();
                });
              },
              onLongPress: () {
                setState(() {
                  _switchState();
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                primary: _getButtonColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                _getButtonText().toUpperCase(),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    switch (_timerState) {
      case TimerState.readyToStart:
        return "Start";
      case TimerState.waiting:
        return "Wait";
      case TimerState.canBeStopped:
        return "Stop";
      case TimerState.disableOnWait:
        return "Return";
    }
  }

  Color _getButtonColor() {
    switch (_timerState) {
      case TimerState.readyToStart:
        return const Color(0xFF40CA88);
      case TimerState.waiting:
        return const Color(0xFFE0982D);
      case TimerState.canBeStopped:
      case TimerState.disableOnWait:
        return const Color(0xFFE02D47);
    }
  }

  void _startWaitingTimer() {
    final int randomSeconds = Random().nextInt(4) + 1;
    _waitingTimer = Timer(Duration(seconds: randomSeconds), () {
      if (_timerState == TimerState.disableOnWait) {
        _timerState = TimerState.readyToStart;
        return;
      }
      setState(() {
        _timerState = TimerState.canBeStopped;
      });
      _startStoppableTime();
    });
  }

  void _startStoppableTime() {
    _stoppableTimer = Timer.periodic(const Duration(milliseconds: 2), (timer) {
      setState(() {
        _millisecondsText = "${timer.tick * 2} ms";
      });
    });
  }

  void _switchState() {
    switch (_timerState) {
      case TimerState.readyToStart:
        _timerState = TimerState.waiting;
        _millisecondsText = "";
        _startWaitingTimer();
        break;
      case TimerState.waiting:
        _waitingTimer?.cancel();
        _timerState = TimerState.disableOnWait;
        break;
      case TimerState.canBeStopped:
        _timerState = TimerState.readyToStart;
        _stoppableTimer?.cancel();
        if (_reviewCounter >= 0) {
          _reviewCounter++;
        }
        if (_reviewCounter > 6) {
          _appearReview();
        }
        break;
      case TimerState.disableOnWait:
        _timerState = TimerState.readyToStart;
        _millisecondsText = "";
        break;
    }
    if (_timerState == TimerState.disableOnWait) {
      _millisecondsText = "TOO EARLY";
    }
  }

  Future<void> _appearReview() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  @override
  void dispose() {
    _waitingTimer?.cancel();
    _stoppableTimer?.cancel();
    _reviewCounter = 0;
    super.dispose();
  }
}

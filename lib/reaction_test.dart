import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';

import 'ad_state.dart';
import 'settings/settings_view.dart';

class ReactionTest extends StatefulWidget {
  const ReactionTest({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  _ReactionTestState createState() => _ReactionTestState();
}

class _ReactionTestState extends State<ReactionTest> {
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
              adUnitId: adState.bannerAdUnitId,
              size: AdSize.banner,
              request: const AdRequest(),
              listener: adState.adListener,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Expanded(child: _Timer()),
            if (_bannerAd != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: AdWidget(ad: _bannerAd!),
                ),
              )
            else
              const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}

class _Timer extends StatefulWidget {
  const _Timer({Key? key}) : super(key: key);

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<_Timer> {
  String _millisecondsText = "";
  int _reviewCounter = 0;
  TimerState _timerState = TimerState.readyToStart;
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
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(30),
            ),
            height: 150,
            width: 400,
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
            width: 170,
            height: 120,
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

enum TimerState { readyToStart, waiting, canBeStopped, disableOnWait }

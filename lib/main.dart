import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:reactiontest/ad_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  runApp(
    Provider.value(
      value: adState,
      builder: (context, child) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String millisecondsText = "";
  GameState gameState = GameState.readyToStart;
  Timer? waitingTimer;
  Timer? stoppableTimer;

  BannerAd? bannerAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        bannerAd = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: AdRequest(),
          listener: adState.adListener,
        )..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF17286C),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text("Test your reaction speed",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ColoredBox(
                        color: Colors.black45,
                        child: SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Center(
                                child: Text(millisecondsText,
                                    style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white))))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _switchState();
                      }),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: _getButtonColor(),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        height: 140,
                        width: 200,
                        child: Text(
                          _getButtonText().toUpperCase(),
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bannerAd == null
                ? SizedBox(height: 50)
                : Container(
                    height: 50,
                    child: AdWidget(ad: bannerAd!),
                    alignment: Alignment.center,
                  )
          ],
        ),
      ),
    );
  }

  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return "Start";
      case GameState.waiting:
        return "Wait";
      case GameState.canBeStopped:
        return "Stop";
      case GameState.disableOnWait:
        return "Return";
    }
  }

  Color _getButtonColor() {
    switch (gameState) {
      case GameState.readyToStart:
        return Color(0xFF40CA88);
      case GameState.waiting:
        return Color(0xFFE0982D);
      case GameState.canBeStopped:
        return Color(0xFFE02D47);
      case GameState.disableOnWait:
        return Color(0xFFE02D47);
    }
  }

  void _startWaitingTimer() {
    final int randomSeconds = Random().nextInt(4) + 1;
    waitingTimer = Timer(Duration(seconds: randomSeconds), () {
      if (gameState == GameState.disableOnWait) {
        gameState = GameState.readyToStart;
        return;
      }
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStoppableTime();
    });
  }

  void _startStoppableTime() {
    stoppableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = "${timer.tick * 16} ms";
      });
    });
  }

  void _switchState() {
    switch (gameState) {
      case GameState.readyToStart:
        gameState = GameState.waiting;
        millisecondsText = "";
        _startWaitingTimer();
        break;
      case GameState.waiting:
        waitingTimer?.cancel();
        gameState = GameState.disableOnWait;
        break;
      case GameState.canBeStopped:
        gameState = GameState.readyToStart;
        stoppableTimer?.cancel();
        break;
      case GameState.disableOnWait:
        gameState = GameState.readyToStart;
        millisecondsText = "";
        break;
    }
    if (gameState == GameState.disableOnWait) {
      millisecondsText = "TIMER DIDN'T START";
    }
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }
}

enum GameState { readyToStart, waiting, canBeStopped, disableOnWait }

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reactiontest/main_page/timer_state.dart';
import 'package:reactiontest/utils.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TimerState _timerState = TimerState.readyToStart;
  String _millisecondsText = '';
  int _reviewCounter = 0;
  Timer? _waitingTimer;
  Timer? _stoppableTimer;
  final Shader _linearGradient = const LinearGradient(
    colors: [
      Color(0xFFE02D47),
      Color(0xFFBD37F5),
    ],
  ).createShader(const Rect.fromLTWH(0, 0, 250, 100));

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Test your reaction speed',
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
                  setState(_switchState);
                },
                onLongPress: () {
                  setState(_switchState);
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

  String _getButtonText() {
    switch (_timerState) {
      case TimerState.readyToStart:
        return 'Start';
      case TimerState.waiting:
        return 'Wait';
      case TimerState.canBeStopped:
        return 'Stop';
      case TimerState.disableOnWait:
        return 'Return';
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
    final randomSeconds = Random().nextInt(4) + 1;
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
        _millisecondsText = '${timer.tick * 2} ms';
      });
    });
  }

  void _switchState() {
    switch (_timerState) {
      case TimerState.readyToStart:
        _timerState = TimerState.waiting;
        _millisecondsText = '';
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
        if (_reviewCounter > 5) {
          appearReview();
        }
        break;
      case TimerState.disableOnWait:
        _timerState = TimerState.readyToStart;
        _millisecondsText = '';
        break;
    }
    if (_timerState == TimerState.disableOnWait) {
      _millisecondsText = 'TOO EARLY';
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

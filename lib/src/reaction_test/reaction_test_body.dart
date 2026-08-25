import 'dart:async';
import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:material_ui/material_ui.dart';
import 'package:reactiontest/src/reaction_test/reaction_state.dart';
import 'package:reactiontest/src/review_service.dart';

class const ReactionTestBody({super.key}) extends StatefulWidget {
  @override
  State<ReactionTestBody> createState() => _ReactionTestBodyState();
}

class _ReactionTestBodyState() extends State<ReactionTestBody> with SingleTickerProviderStateMixin {
  static const _reviewAttemptThreshold = 5;
  static const _brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE02D47), Color(0xFFBD37F5)],
  );

  ReactionState _state = ReactionState.ready;
  String _result = '';
  int _completedAttempts = 0;
  Timer? _waitingTimer;
  Ticker? _ticker;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            children: [
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: _brandGradient.createShader,
                child: Text(
                  'How fast are you?',
                  textAlign: TextAlign.center,
                  style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _instruction,
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 190,
                child: Center(
                  child: Text(
                    _displayText,
                    textAlign: TextAlign.center,
                    style: textTheme.displayLarge?.copyWith(color: _resultColor, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 260,
                height: 96,
                child: FilledButton(
                  onPressed: _state == ReactionState.waiting ? null : _handleTap,
                  style: FilledButton.styleFrom(
                    backgroundColor: _buttonColor,
                    disabledBackgroundColor: const Color(0xFFE0982D).withValues(alpha: 0.55),
                    disabledForegroundColor: Colors.white70,
                    foregroundColor: Colors.white,
                    textStyle: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  child: Text(_buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _instruction => switch (_state) {
    ReactionState.ready => 'Tap start, then wait for the panel to turn green.',
    ReactionState.waiting => 'Stay focused. The timer has not started yet.',
    ReactionState.canStop => 'Tap now!',
  };

  String get _displayText => switch (_state) {
    ReactionState.ready => _result.isEmpty ? 'WAIT' : _result,
    ReactionState.waiting => 'WAIT',
    ReactionState.canStop => _result,
  };

  String get _buttonText => switch (_state) {
    ReactionState.ready => 'START',
    ReactionState.waiting => 'WAIT…',
    ReactionState.canStop => 'STOP',
  };

  Color get _buttonColor => switch (_state) {
    ReactionState.ready => const Color(0xFF30B978),
    ReactionState.waiting => const Color(0xFFE0982D),
    ReactionState.canStop => const Color(0xFFE02D47),
  };

  Color get _resultColor => switch (_state) {
    ReactionState.ready => const Color(0xFF8E3AD8),
    ReactionState.waiting => const Color(0xFFE0982D),
    ReactionState.canStop => const Color(0xFF30B978),
  };

  void _handleTap() {
    switch (_state) {
      case ReactionState.ready:
        setState(() {
          _state = ReactionState.waiting;
          _result = '';
        });
        _startWaitingTimer();
        return;
      case ReactionState.waiting:
        // The button is disabled while waiting, so the timer cannot be stopped early.
        return;
      case ReactionState.canStop:
        _stopTicker();
        setState(() => _state = ReactionState.ready);
        _completedAttempts++;
        if (_completedAttempts >= _reviewAttemptThreshold) {
          _completedAttempts = 0;
          unawaited(requestAppReview());
        }
        return;
    }
  }

  void _startWaitingTimer() {
    final delay = Duration(seconds: Random().nextInt(4) + 1);
    _waitingTimer = Timer(delay, () {
      if (!mounted || _state != ReactionState.waiting) {
        return;
      }
      setState(() {
        _state = ReactionState.canStop;
        _result = '0 ms';
      });
      _startTicker();
    });
  }

  void _startTicker() {
    _stopTicker();
    _ticker = createTicker((elapsed) {
      if (mounted) {
        setState(() => _result = '${elapsed.inMilliseconds} ms');
      }
    })..start();
  }

  void _stopTicker() {
    _ticker?.dispose();
    _ticker = null;
  }

  @override
  void dispose() {
    _waitingTimer?.cancel();
    _stopTicker();
    super.dispose();
  }
}

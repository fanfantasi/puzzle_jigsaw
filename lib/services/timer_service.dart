// timer_service.dart
import 'dart:async';
import 'package:ai_puzzle/services/audio_service.dart';
import 'package:flutter/material.dart';

class TimerService with ChangeNotifier {
  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalTime = 0;
  bool _isRunning = false;
  Function()? _onTimeUp;

  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  int get totalTime => _totalTime;

  final AudioService _audioService = AudioService();

  String get formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get progress => _totalTime > 0 ? (_remainingSeconds / _totalTime) : 0.0;

  void startTimer(int seconds, {Function()? onTimeUp}) {
    _totalTime = seconds;
    _remainingSeconds = seconds;
    _onTimeUp = onTimeUp;
    _isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        if (_remainingSeconds > 0 && _remainingSeconds <= 5) {
          // panggil tanpa await biar tidak blocking
          _audioService.playBeep();
        }

        notifyListeners();
      } else {
        _onTimeUp?.call();
        stopTimer();
      }
    });

    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    stopTimer();
    _remainingSeconds = 0;
    _totalTime = 0;
    notifyListeners();
  }

  void addTime(int seconds) {
    _remainingSeconds += seconds;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color getTimerColor() {
    if (progress > 0.5) return const Color(0xFF00FF57);
    if (progress > 0.2) return const Color(0xFFFFA500);
    return const Color(0xFFFF2D55);
  }

  Color get timerColor {
    if (progress > 0.5) return const Color(0xFF2ECC71);
    if (progress > 0.2) return const Color(0xFFFFA500);
    return const Color(0xFFFF2D55);
  }
}

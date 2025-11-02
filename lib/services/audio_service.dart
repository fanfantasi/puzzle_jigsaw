import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final List<AudioPlayer> _playerPool = List.generate(3, (_) => AudioPlayer());
  int _currentIndex = 0;
  bool _isMuted = false;
  bool _isInitialized = false;

  bool get isMuted => _isMuted;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // 🔧 Set audio context untuk sound effects (biar bisa bareng music)
    await AudioPlayer.global.setAudioContext(
      AudioContext(
        iOS: AudioContextIOS(category: AVAudioSessionCategory.playback, options: {AVAudioSessionOptions.mixWithOthers}),
        android: const AudioContextAndroid(
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.game,
          audioFocus: AndroidAudioFocus.none,
        ),
      ),
    );

    for (final p in _playerPool) {
      await p.setReleaseMode(ReleaseMode.stop);
    }

    final prefs = await SharedPreferences.getInstance();
    _isMuted = prefs.getBool('audioMuted') ?? false;

    for (final p in _playerPool) {
      await p.setVolume(_isMuted ? 0.0 : 1.0);
    }

    _isInitialized = true;
    notifyListeners();
  }

  AudioPlayer get _nextPlayer {
    _currentIndex = (_currentIndex + 1) % _playerPool.length;
    return _playerPool[_currentIndex];
  }

  Future<void> _play(String assetPath) async {
    if (_isMuted) return;
    try {
      final player = _nextPlayer;
      await player.stop();
      await player.play(AssetSource(assetPath));
      debugPrint('🔊 Playing: $assetPath');
    } catch (e) {
      debugPrint('⚠️ Error playing $assetPath: $e');
    }
  }

  Future<void> playClick() => _play('audio/click.wav');
  Future<void> playBeep() => _play('audio/beep.mp3');
  Future<void> playWin() => _play('audio/won.wav');
  Future<void> playLose() => _play('audio/failed.wav');
  Future<void> playPick() => _play('audio/pick.mp3');

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    for (final p in _playerPool) {
      await p.setVolume(_isMuted ? 0.0 : 1.0);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('audioMuted', _isMuted);
    notifyListeners();
  }

  Future<void> disposeAudio() async {
    for (final p in _playerPool) {
      await p.dispose();
    }
  }
}

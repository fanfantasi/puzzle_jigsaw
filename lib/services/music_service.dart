import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicService extends ChangeNotifier {
  static final MusicService _instance = MusicService._internal();
  factory MusicService() => _instance;
  MusicService._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  bool _isInitialized = false;
  bool _isMuted = false;
  bool _isPlaying = false;
  double _volume = 0.7;

  bool get isMuted => _isMuted;
  bool get isPlaying => _isPlaying;
  double get volume => _volume;

  static const _musicPath = 'audio/instrumental.mp3';

  Future<void> initialize() async {
    if (_isInitialized) return;

    // 🔧 Set audio context khusus untuk music playback
    await AudioPlayer.global.setAudioContext(
      AudioContext(
        iOS: AudioContextIOS(category: AVAudioSessionCategory.playback, options: {AVAudioSessionOptions.mixWithOthers}),
        android: const AudioContextAndroid(
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.media,
          audioFocus: AndroidAudioFocus.none,
        ),
      ),
    );

    await _musicPlayer.setReleaseMode(ReleaseMode.loop);

    final prefs = await SharedPreferences.getInstance();
    _isMuted = prefs.getBool('musicMuted') ?? false;

    await _musicPlayer.setVolume(_isMuted ? 0.0 : _volume);
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> playMusic() async {
    if (_isMuted) return;
    try {
      await _musicPlayer.stop();
      await _musicPlayer.play(AssetSource(_musicPath));
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint('⚠️ Error playing music: $e');
    }
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    await _musicPlayer.setVolume(_isMuted ? 0.0 : _volume);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('musicMuted', _isMuted);
    notifyListeners();
  }
}

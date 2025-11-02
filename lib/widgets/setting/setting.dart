import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ai_puzzle/services/audio_service.dart';
import 'package:ai_puzzle/services/music_service.dart';

class SettingsDialogContent extends StatefulWidget {
  const SettingsDialogContent({super.key});

  @override
  State<SettingsDialogContent> createState() => _SettingsDialogContentState();
}

class _SettingsDialogContentState extends State<SettingsDialogContent> with SingleTickerProviderStateMixin {
  final musicService = MusicService();
  final audioService = AudioService();

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool soundOn = true;
  bool musicOn = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();

    soundOn = !audioService.isMuted;
    musicOn = !musicService.isMuted;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1ABC9C), Color.fromARGB(255, 13, 146, 119)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .4), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 32),
                      const Text(
                        "SETTINGS",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.white.withValues(alpha: .3), thickness: 1),

                  const SizedBox(height: 20),

                  // Sound switch
                  _buildRow(
                    icon: Icons.volume_up,
                    label: "Sound",
                    value: soundOn,
                    onChanged: (val) {
                      setState(() => soundOn = val);
                      audioService.toggleMute();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Music switch
                  _buildRow(
                    icon: Icons.music_note,
                    label: "Music",
                    value: musicOn,
                    onChanged: (val) {
                      setState(() => musicOn = val);
                      musicService.toggleMute();
                    },
                  ),

                  const SizedBox(height: 30),

                  // Exit button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [Color.fromARGB(255, 16, 115, 95), Color.fromARGB(255, 13, 146, 119)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), offset: const Offset(0, 3), blurRadius: 6)],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.exit_to_app, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            "Exit",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// --- Item row with switch ---
  Widget _buildRow({required IconData icon, required String label, required bool value, required ValueChanged<bool> onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        _buildCustomSwitch(value: value, onChanged: onChanged),
      ],
    );
  }

  /// --- Custom Switch ---
  Widget _buildCustomSwitch({required bool value, required Function(bool) onChanged}) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 70,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: value ? Colors.green : const Color(0xFFD32F2F).withValues(alpha: .8),
          border: Border.all(color: Colors.white.withValues(alpha: .6), width: 1.5),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.all(3),
                width: 38,
                height: 28,
                decoration: BoxDecoration(
                  color: value ? Color(0xFF0E6B30) : Color.fromARGB(255, 167, 19, 19),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    value ? "ON" : "OFF",
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

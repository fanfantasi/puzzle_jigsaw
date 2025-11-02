import 'package:ai_puzzle/pages/jigsaw_home.dart';
import 'package:ai_puzzle/services/puzzle_service.dart';
import 'package:ai_puzzle/widgets/background/background.dart';
import 'package:ai_puzzle/widgets/text/text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class GradientLoadingScreen extends StatefulWidget {
  const GradientLoadingScreen({super.key});

  @override
  State<GradientLoadingScreen> createState() => _GradientLoadingScreenState();
}

class _GradientLoadingScreenState extends State<GradientLoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));

    // 🔹 Jalankan animasi sekali
    _controller.forward();

    // 🔹 Pindah halaman saat animasi selesai
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const JigsawHome()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PuzzleProvider>(
        builder: (context, notifier, _) {
          return Stack(
            children: [
              GameBackground(puzzle: notifier, overlayColor: Colors.greenAccent.withValues(alpha: 0.2), blurSigmaX: 5.0, blurSigmaY: 5.0),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double progress = _controller.value;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: kToolbarHeight),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            GameTitleText(text: 'PUZZLE GAME', gradientColors: [Color(0xFF3498DB), Color(0xFF2E86DE)], fontSize: 48),
                            GameTitleText(text: 'ARENA', gradientColors: [Color(0xFFFFF176), Color(0xFFFF9800)], fontSize: 62),
                          ],
                        ),
                        SizedBox(height: 64),
                        Lottie.asset('assets/lottie/loading.json', width: 180, height: 180, repeat: true),
                        const SizedBox(height: 12),
                        Container(
                          width: 280,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withValues(alpha: 0.2),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          alignment: Alignment.centerLeft,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 280 * progress,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [Colors.orange, Colors.deepOrange],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              boxShadow: [BoxShadow(color: Colors.blueAccent.withValues(alpha: .6), blurRadius: 10, spreadRadius: 1)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

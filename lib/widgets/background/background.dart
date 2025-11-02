import 'dart:ui';
import 'package:ai_puzzle/services/puzzle_service.dart';
import 'package:flutter/material.dart';

class GameBackground extends StatelessWidget {
  final PuzzleProvider puzzle;
  final Color overlayColor;
  final double blurSigmaX;
  final double blurSigmaY;

  const GameBackground({
    super.key,
    required this.puzzle,
    this.overlayColor = const Color(0x4DFFFFFF), // soft putih transparan
    this.blurSigmaX = 15.0,
    this.blurSigmaY = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 🖼 Background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: puzzle.fullImageBytes != null ? MemoryImage(puzzle.fullImageBytes!) : const AssetImage('assets/bg-2.png') as ImageProvider,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),

        // 🌫 Efek kaca (frosted glass)
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigmaX, sigmaY: blurSigmaY),
          child: Container(
            decoration: BoxDecoration(
              color: overlayColor,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.black.withValues(alpha: 0.25), Colors.black.withValues(alpha: 0.05)],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.2),
              boxShadow: [BoxShadow(color: Colors.white.withValues(alpha: 0.08), blurRadius: 20, spreadRadius: 2)],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameTitleText extends StatelessWidget {
  final String text;
  final List<Color> gradientColors;
  final double fontSize;
  final double shadowOffset;
  final double shadowBlur;
  final Color shadowColor;

  const GameTitleText({
    super.key,
    required this.text,
    required this.gradientColors,
    this.fontSize = 72,
    this.shadowOffset = 4,
    this.shadowBlur = 6,
    this.shadowColor = const Color(0x80000000),
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: gradientColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.titanOne(
          fontSize: fontSize,
          letterSpacing: 2,
          height: 0.9,
          color: Colors.white, // ini akan diganti oleh shader
          shadows: [Shadow(color: shadowColor, offset: Offset(0, shadowOffset), blurRadius: shadowBlur)],
        ),
      ),
    );
  }
}

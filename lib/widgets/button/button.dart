import 'package:ai_puzzle/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameButton extends StatefulWidget {
  final String? text;
  final String? icon;
  final LinearGradient gradient;
  final Color? shadowColor;
  final Color borderColor;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final VoidCallback onPressed;
  final bool iconOnRight;
  final double radius;
  final double? fontSize;

  const GameButton({
    super.key,
    this.text,
    this.icon,
    required this.gradient,
    this.shadowColor,
    required this.borderColor,
    required this.onPressed,
    required this.radius,
    this.width = 220,
    this.height = 60,
    this.fontSize = 22,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.iconOnRight = true,
  });

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  double _scale = 1.0;

  final AudioService _audioService = AudioService();

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.9);
    _audioService.playPick();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.text != null && widget.text!.isNotEmpty;
    final hasIcon = widget.icon != null && widget.icon!.isNotEmpty;

    // 🔹 Tentukan alignment row berdasarkan isi
    final mainAxisSize = MainAxisSize.max;
    final mainAxisAlignment = (hasText && hasIcon) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: widget.gradient,
            border: Border.all(width: 2, color: widget.borderColor),
            boxShadow: widget.shadowColor != null ? [BoxShadow(color: widget.shadowColor!, offset: const Offset(0, 6), blurRadius: 8)] : [],
          ),
          padding: widget.padding,
          child: Row(
            mainAxisSize: mainAxisSize,
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (hasIcon && !widget.iconOnRight) Image.asset(widget.icon!, width: 30, height: 30),

              if (hasIcon && hasText && !widget.iconOnRight) const SizedBox(width: 8),

              if (hasText)
                Text(
                  widget.text!,
                  style: GoogleFonts.signika(
                    fontSize: widget.fontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 2)],
                  ),
                ),

              if (hasText && hasIcon && widget.iconOnRight) const SizedBox(width: 8),

              if (hasIcon && widget.iconOnRight) Image.asset(widget.icon!, width: 24, height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:ai_puzzle/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameAppBar extends StatelessWidget {
  final String? title;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const GameAppBar({super.key, this.title, this.onBack, this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: .1),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Transform.translate(
        offset: const Offset(0, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tombol back (opsional)
            if (onBack != null)
              GameButton(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                gradient: const LinearGradient(
                  colors: [Color(0xFF3498DB), Color(0xFF2E86DE)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderColor: Color(0xFF3498DB),
                shadowColor: const Color(0xFF0C4370),
                icon: 'assets/icons/back.png',
                width: 52,
                height: 42,
                radius: 8,
                onPressed: onBack!,
              )
            else
              const SizedBox(width: 40), // Placeholder agar title tetap di tengah
            // Title
            Expanded(
              child: Center(
                child: Text(
                  title ?? '',
                  style: GoogleFonts.signika(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
                ),
              ),
            ),

            // Actions kanan (opsional)
            if (actions != null && actions!.isNotEmpty) Row(children: actions!) else const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }
}

import 'package:ai_puzzle/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameCoinDisplay extends StatelessWidget {
  final String coins;
  final VoidCallback onAddPressed;

  const GameCoinDisplay({super.key, required this.coins, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomLeft: Radius.circular(24),
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .4), offset: const Offset(0, 4), blurRadius: 6)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/icons/coin.png', width: 32),

          const SizedBox(width: 8),

          // 💲 Coin Value
          SizedBox(
            width: 42,
            child: Text(
              coins.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.signika(
                color: Colors.white,
                fontSize: 22,
                shadows: [Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 2)],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ➕ Add Button
          GameButton(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            gradient: const LinearGradient(colors: [Color(0xFF4CD964), Color(0xFF1ABC9C)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            borderColor: Color(0xFF1ABC9C),
            icon: 'assets/icons/plus.png',
            width: 34,
            height: 34,
            radius: 8,
            onPressed: () {
              // TODO: navigate to normal mode
            },
          ),
        ],
      ),
    );
  }
}

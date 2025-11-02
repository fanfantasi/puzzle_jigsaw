import 'package:ai_puzzle/pages/jigsaw_level.dart';
import 'package:ai_puzzle/services/music_service.dart';
import 'package:ai_puzzle/services/puzzle_service.dart';
import 'package:ai_puzzle/widgets/admob/native_banner.dart';
import 'package:ai_puzzle/widgets/background/background.dart';
import 'package:ai_puzzle/widgets/button/button.dart';
import 'package:ai_puzzle/widgets/text/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/config.dart';

class JigsawHome extends StatefulWidget {
  const JigsawHome({super.key});

  @override
  State<JigsawHome> createState() => _JigsawHomeState();
}

class _JigsawHomeState extends State<JigsawHome> {
  final musicService = MusicService();

  @override
  void initState() {
    musicService.initialize();
    musicService.playMusic();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PuzzleProvider>(
        builder: (context, notifier, _) {
          return Stack(
            children: [
              GameBackground(puzzle: notifier, overlayColor: Colors.greenAccent.withValues(alpha: 0.2), blurSigmaX: 5.0, blurSigmaY: 5.0),
              Container(
                height: kToolbarHeight * 2,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // GameCoinDisplay(
                    //   coins: '10K',
                    //   onAddPressed: () {
                    //     print('Add coin clicked!');
                    //   },
                    // ),
                    SizedBox(),
                    GameButton(
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3498DB), Color(0xFF2E86DE)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderColor: Color(0xFF3498DB),
                      shadowColor: const Color(0xFF0C4370),
                      icon: 'assets/icons/setting.png',
                      width: 38,
                      height: 38,
                      radius: 8,
                      onPressed: () {
                        notifier.showSettingsDialog(context);
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: kToolbarHeight * 1.5,
                left: 0,
                right: 0,
                bottom: 0,
                child: FractionallySizedBox(
                  heightFactor: 0.85, // sedikit turun agar visualnya pas di tengah
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      GameButton(
                        text: "Classic",
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CD964), Color(0xFF1ABC9C)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        shadowColor: const Color(0xFF0E6B30),
                        borderColor: Color(0xFF1ABC9C),
                        icon: 'assets/icons/play.png',
                        radius: 18,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const LevelScreen(title: 'Classic')));
                        },
                      ),
                      const SizedBox(height: 20),
                      GameButton(
                        text: "Modern",
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3498DB), Color(0xFF2E86DE)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderColor: Color(0xFF2E86DE),
                        shadowColor: const Color(0xFF0C4370),
                        icon: 'assets/icons/play.png',
                        radius: 18,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const LevelScreen(title: 'Modern')));
                        },
                      ),
                      const SizedBox(height: 20),
                      GameButton(
                        text: "Ultimate",
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF5C83), Color(0xFFD32F6E)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderColor: Color(0xFFD32F6E),
                        shadowColor: const Color(0xFF6D1136),
                        icon: 'assets/icons/play.png',
                        radius: 18,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const LevelScreen(title: 'Ultimate')));
                        },
                      ),
                      Spacer(),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12.0),
                        width: MediaQuery.of(context).size.width,
                        child: NativeBannerAdWidget(unitId: adMobId),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

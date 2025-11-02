import 'package:ai_puzzle/pages/jigsaw_screen.dart';
import 'package:ai_puzzle/pages/jigsaw_topbar.dart';
import 'package:ai_puzzle/services/puzzle_service.dart';
import 'package:ai_puzzle/widgets/admob/native_banner.dart';
import 'package:ai_puzzle/widgets/background/background.dart';
import 'package:ai_puzzle/widgets/button/button.dart';
import 'package:ai_puzzle/widgets/jigsaw/jigsaw_path_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/config.dart';

class LevelScreen extends StatefulWidget {
  final String title;
  const LevelScreen({super.key, required this.title});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PuzzleProvider>(
        builder: (context, notifier, _) {
          return Stack(
            children: [
              GameBackground(puzzle: notifier, overlayColor: Colors.greenAccent.withValues(alpha: 0.2), blurSigmaX: 5.0, blurSigmaY: 5.0),
              SizedBox(
                height: kToolbarHeight * 1.5,
                child: GameAppBar(
                  title: widget.title,
                  onBack: () {
                    Navigator.pop(context);
                  },
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
                    children: [
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2, // jumlah kolom = 2
                          mainAxisSpacing: 12, // jarak antar baris
                          crossAxisSpacing: 12, // jarak antar kolom
                          padding: const EdgeInsets.all(16),
                          children: [
                            GameButton(
                              text: "2 x 2",
                              fontSize: 64,
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4CD964), Color(0xFF1ABC9C)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              shadowColor: const Color(0xFF0E6B30),
                              borderColor: Color(0xFF1ABC9C),
                              radius: 18,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => JigsawScreen(
                                      level: 2,
                                      type: widget.title == 'Classic'
                                          ? JigsawPathType.classic
                                          : widget.title == 'Modern'
                                          ? JigsawPathType.spike
                                          : JigsawPathType.classicModern,
                                      title: widget.title,
                                    ),
                                  ),
                                );
                              },
                            ),
                            GameButton(
                              text: "3 x 3",
                              fontSize: 64,
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3498DB), Color(0xFF2E86DE)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderColor: Color(0xFF2E86DE),
                              shadowColor: const Color(0xFF0C4370),
                              radius: 18,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => JigsawScreen(
                                      level: 3,
                                      type: widget.title == 'Classic'
                                          ? JigsawPathType.classic
                                          : widget.title == 'Modern'
                                          ? JigsawPathType.spike
                                          : JigsawPathType.classicModern,
                                      title: widget.title,
                                    ),
                                  ),
                                );
                              },
                            ),
                            GameButton(
                              text: "4 x 4",
                              fontSize: 64,
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFA726), Color(0xFFF57C00)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderColor: const Color(0xFFF57C00),
                              shadowColor: const Color(0xFF7C3F00),

                              radius: 18,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => JigsawScreen(
                                      level: 4,
                                      type: widget.title == 'Classic'
                                          ? JigsawPathType.classic
                                          : widget.title == 'Modern'
                                          ? JigsawPathType.spike
                                          : JigsawPathType.classicModern,
                                      title: widget.title,
                                    ),
                                  ),
                                );
                              },
                            ),
                            GameButton(
                              text: "5 x 5",
                              fontSize: 64,
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6B6B), Color(0xFFC0392B)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderColor: const Color(0xFFC0392B),
                              shadowColor: const Color(0xFF641E16),

                              radius: 18,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => JigsawScreen(
                                      level: 5,
                                      type: widget.title == 'Classic'
                                          ? JigsawPathType.classic
                                          : widget.title == 'Modern'
                                          ? JigsawPathType.spike
                                          : JigsawPathType.classicModern,
                                      title: widget.title,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12.0),
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: NativeBannerAdWidget(unitId: adMobId2),
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

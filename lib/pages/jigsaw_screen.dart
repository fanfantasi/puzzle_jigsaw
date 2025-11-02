import 'package:ai_puzzle/pages/jigsaw_topbar.dart';
import 'package:ai_puzzle/services/puzzle_service.dart';
import 'package:ai_puzzle/services/timer_service.dart';
import 'package:ai_puzzle/widgets/admob/admob.dart';
import 'package:ai_puzzle/widgets/background/background.dart';
import 'package:ai_puzzle/widgets/button/button.dart';
import 'package:ai_puzzle/widgets/jigsaw/jigsaw_path_utils.dart';
import 'package:ai_puzzle/widgets/jigsaw/jigsaw_puzzle.dart';
import 'package:ai_puzzle/widgets/jigsaw/jigsaw_widget.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:ai_puzzle/services/audio_service.dart';
import 'package:ai_puzzle/services/config.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class JigsawScreen extends StatefulWidget {
  final int level;
  final JigsawPathType type;
  final String title;
  const JigsawScreen({super.key, required this.level, required this.type, required this.title});

  @override
  State<JigsawScreen> createState() => _JigsawScreenState();
}

class _JigsawScreenState extends State<JigsawScreen> with SingleTickerProviderStateMixin {
  final GlobalKey _puzzleAreaKey = GlobalKey();

  final GlobalKey<JigsawWidgetState> puzzleKey = GlobalKey<JigsawWidgetState>();
  final GlobalKey<JigsawPuzzleState> puzzleTimerKey = GlobalKey<JigsawPuzzleState>();

  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  late PuzzleProvider puzzleNotifier;
  late TimerService timerNotifier;

  late AudioService audio;

  bool completed = false;
  bool showConfetti = false;
  bool showShimmer = false;

  @override
  void initState() {
    super.initState();
    _initializeAudio();
    puzzleNotifier = context.read<PuzzleProvider>();
    timerNotifier = context.read<TimerService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      puzzleNotifier.newPuzzle();
    });
    _shimmerController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut));
  }

  Future<void> _initializeAudio() async {
    audio = context.read<AudioService>();
  }

  @override
  void dispose() {
    if (mounted) {
      _shimmerController.dispose();
    }
    super.dispose();
  }

  Future<void> _handleGenerate() async {
    setState(() {
      completed = false;
      showConfetti = false;
      showShimmer = false;
    });

    print('🎮 Starting generate process...');
    timerNotifier.resetTimer();
    try {
      await puzzleNotifier.newPuzzle();
      await Future.delayed(Duration(milliseconds: 200));

      print('✅ Online image loaded');
    } catch (e) {
      print('❌ Online image failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal memuat gambar online. Menggunakan gambar lokal.')));
      }
    }

    // ✅ CHECK NULL DULU
    if (puzzleKey.currentState == null) {
      print('❌ puzzleKey.currentState is NULL');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Puzzle belum siap. Coba lagi.')));
      }
      return;
    }

    // print('🔄 Generating puzzle...');
    // await puzzleTimerKey.currentState?.generatePuzzleWithTimer();
    // await puzzleKey.currentState!.generate(); // Sekarang aman pakai !
    // print('✅ Puzzle generated');
  }

  Future<void> _handleStart() async {
    // await puzzleTimerKey.currentState?.generatePuzzleWithTimer();
    await puzzleKey.currentState!.generate(); // Sekarang aman pakai !
    setState(() {
      completed = false;
      showConfetti = false;
      showShimmer = false;
    });
  }

  void _handleClear() async {
    puzzleKey.currentState!.reset();
    timerNotifier.resetTimer();
    setState(() {
      completed = false;
      showConfetti = false;
      showShimmer = false;
    });
  }

  void _handleFinished() {
    audio.playWin();
    _shimmerController.forward(from: 0);
    setState(() {
      completed = true;
      showConfetti = true;
    });
  }

  void _handleTimeUp() {
    print('⏰ TIME\'S UP!');
    audio.playLose();
    puzzleKey.currentState!.reset();
    setState(() {
      completed = false;
      showConfetti = false;
      showShimmer = false;
    });
    Future.delayed(Duration(seconds: 2), () {
      AdManager().showRewardedAd(() {
        debugPrint('User watched ad, bisa kasih reward');
        // contoh: tambah nyawa / continue
      });
    });
  }

  void _handleBlockSuccess() {
    print('block success!');
    audio.playClick();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      body: Consumer2<PuzzleProvider, TimerService>(
        builder: (context, notifier, timerNotifier, _) {
          return Stack(
            children: [
              GameBackground(puzzle: notifier, overlayColor: Color(0xFFCCE3F8).withValues(alpha: .5), blurSigmaX: 12.0, blurSigmaY: 12.0),
              SizedBox(
                height: kToolbarHeight * 1.5,
                child: GameAppBar(
                  title: widget.title,
                  onBack: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // Main Content
              Positioned(
                top: kToolbarHeight * 1.7,
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  children: [
                    // Header Buttons
                    _buildHeader(notifier, timerNotifier),
                    // Puzzle Area
                    notifier.isLoading ? Center(child: _buildLoading()) : _buildPuzzleArea(notifier),
                  ],
                ),
              ),

              // Confetti Overlay
              if (completed) _buildConfettiOverlay(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie/loading.json', width: 180, height: 180, repeat: true),
            const SizedBox(height: 20),
            const Text(
              "Please Wait...",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(PuzzleProvider puzzle, TimerService timer) {
    final color = timer.timerColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: ResponsiveValue(context, defaultValue: 120.0, valueWhen: const [Condition.smallerThan(name: MOBILE, value: 160.0)]).value,
            width: ResponsiveValue(context, defaultValue: 120.0, valueWhen: const [Condition.smallerThan(name: MOBILE, value: 160.0)]).value,
            child: ClayContainer(
              color: baseColor,
              borderRadius: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image(
                    fit: BoxFit.cover,
                    image: puzzle.fullImageBytes != null
                        ? MemoryImage(puzzle.fullImageBytes!) // Dari provider
                        : const AssetImage('assets/default.jpg'),
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  GameButton(
                    text: "Generate",
                    fontSize: 16,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFA726), Color(0xFFF57C00)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderColor: const Color(0xFFF57C00),
                    shadowColor: const Color(0xFF7C3F00),
                    icon: 'assets/icons/generate.png',
                    radius: 18,
                    width: 120,
                    height: kToolbarHeight,
                    onPressed: _handleGenerate,
                  ),
                  const SizedBox(width: 16),
                  GameButton(
                    text: "Clear",
                    fontSize: 16,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF5C8D), Color(0xFFD32F2F)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderColor: const Color(0xFFD32F2F),
                    shadowColor: const Color(0xFF7A1C1C),
                    radius: 18,
                    width: 80,
                    height: kToolbarHeight,
                    onPressed: _handleClear,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GameButton(
                text: timer.isRunning ? timer.formattedTime : "Start",
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: .9), color.withValues(alpha: .6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                shadowColor: color.withValues(alpha: .4),
                borderColor: color,

                icon: timer.isRunning ? '' : 'assets/icons/play.png',
                radius: 18,
                fontSize: timer.isRunning ? 24 : 16,
                height: kToolbarHeight,
                onPressed: _handleStart,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPuzzleArea(PuzzleProvider notifier) {
    final puzzle = JigsawPuzzle(
      key: _puzzleAreaKey,
      gridSize: widget.level,
      image: notifier.fullImageBytes != null ? MemoryImage(notifier.fullImageBytes!) : const AssetImage('assets/bg-1.jpg'),
      onFinished: _handleFinished,
      onTimeUp: _handleTimeUp,
      snapSensitivity: .5,
      puzzleKey: puzzleKey,
      pathType: widget.type,
      timeLimitInSeconds: notifier.getTimeLimit(widget.level),
      onBlockSuccess: _handleBlockSuccess,
    );
    final shimmerEffect = AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return IgnorePointer(
          child: CustomPaint(
            painter: _ShimmerPainter(progress: _shimmerAnimation.value),
            child: SizedBox(width: notifier.imageSize!.width * .66, height: notifier.imageSize!.height * .66),
          ),
        );
      },
    );

    return Stack(
      children: [
        puzzle,
        if (showConfetti) _buildConfettiOverlay(),
        if (showShimmer) Align(alignment: Alignment.center, child: shimmerEffect),
      ],
    );
  }

  Widget _buildConfettiOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: Lottie.asset(
          'assets/lottie/confetti.json',
          repeat: false,
          onLoaded: (composition) {
            Future.delayed(composition.duration, () {
              setState(() {
                showConfetti = false;
                showShimmer = true;
              });
              _shimmerController.forward(from: 0);
              Future.delayed(const Duration(seconds: 2), () {
                puzzleKey.currentState?.reset();
                setState(() => showShimmer = false);
                Future.delayed(Duration(seconds: 2), () {
                  AdManager().showRewardedAd(() {
                    debugPrint('User watched ad, bisa kasih reward');
                    // contoh: tambah nyawa / continue
                  });
                });
              });
            });
          },
        ),
      ),
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  final double progress;

  _ShimmerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      colors: [Colors.transparent, Colors.white.withValues(alpha: .6), Colors.transparent],
      stops: const [0.4, 0.5, 0.6],
      begin: Alignment(-1 + progress * 2, -1),
      end: Alignment(progress * 2, 1),
    );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..blendMode = BlendMode.lighten;

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _ShimmerPainter oldDelegate) => oldDelegate.progress != progress;
}

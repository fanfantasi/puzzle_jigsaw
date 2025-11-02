import 'package:ai_puzzle/widgets/jigsaw/jigsaw_path_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/timer_service.dart';
import 'jigsaw_widget.dart';

class JigsawPuzzle extends StatefulWidget {
  const JigsawPuzzle({
    super.key,
    required this.gridSize,
    required this.image,
    required this.puzzleKey,
    this.onFinished,
    this.onBlockSuccess,
    this.onGenerate,
    this.onTimeUp,
    this.outlineCanvas = true,
    this.autoStart = false,
    this.snapSensitivity = .5,
    this.pathType = JigsawPathType.classic,
    this.timeLimitInSeconds = 0,
  });

  final int gridSize;
  final Function()? onFinished;
  final Function()? onBlockSuccess;
  final Function()? onTimeUp;
  final Function()? onGenerate;
  final ImageProvider image;
  final bool autoStart;
  final bool outlineCanvas;
  final double snapSensitivity;
  final JigsawPathType pathType;
  final GlobalKey<JigsawWidgetState> puzzleKey;
  final int timeLimitInSeconds;

  @override
  JigsawPuzzleState createState() => JigsawPuzzleState();
}

class JigsawPuzzleState extends State<JigsawPuzzle> {
  late TimerService timerNotifier;

  @override
  void initState() {
    super.initState();
    timerNotifier = context.read<TimerService>();
  }

  void startTimer() {
    if (widget.timeLimitInSeconds > 0 && !timerNotifier.isRunning) {
      timerNotifier.startTimer(
        widget.timeLimitInSeconds,
        onTimeUp: () {
          widget.onTimeUp?.call();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerService>(
      builder: (context, timerNotifier, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            if (timerNotifier.isRunning) timer(timerNotifier),
            JigsawWidget(
              callbackFinish: () {
                timerNotifier.stopTimer();
                widget.onFinished?.call();
              },
              callbackSuccess: () {
                widget.onBlockSuccess?.call();
              },
              callbackGenerate: () {
                timerNotifier.stopTimer();
                widget.onGenerate?.call();
                startTimer();
              },
              key: widget.puzzleKey,
              gridSize: widget.gridSize,
              snapSensitivity: widget.snapSensitivity,
              outlineCanvas: widget.outlineCanvas,
              pathType: widget.pathType,
              child: Image(fit: BoxFit.contain, image: widget.image),
            ),
          ],
        );
      },
    );
  }

  Widget timer(TimerService notifier) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
        height: 8,
        color: Colors.black.withValues(alpha: .4),
        alignment: Alignment.centerLeft,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: notifier.progress.clamp(0.0, 1.0)),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) {
            return FractionallySizedBox(
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [notifier.getTimerColor().withValues(alpha: 0.9), notifier.getTimerColor()],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [BoxShadow(color: notifier.getTimerColor().withValues(alpha: .7), blurRadius: 10, spreadRadius: 1)],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ShimmerPuzzleWrapper extends StatefulWidget {
  final Widget child;
  final bool isFinished;

  const ShimmerPuzzleWrapper({super.key, required this.child, required this.isFinished});

  @override
  State<ShimmerPuzzleWrapper> createState() => _ShimmerPuzzleWrapperState();
}

class _ShimmerPuzzleWrapperState extends State<ShimmerPuzzleWrapper> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  void didUpdateWidget(covariant ShimmerPuzzleWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFinished && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isFinished && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isFinished)
          IgnorePointer(
            child: Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(painter: _ShimmerPainter(_controller.value));
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  final double progress;

  _ShimmerPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final shader = ui.Gradient.linear(
      Offset(-size.width + (size.width * 2 * progress), 0),
      Offset(size.width * 2 * progress, size.height),
      [Colors.transparent, Colors.white.withOpacity(0.5), Colors.transparent],
      const [0.35, 0.5, 0.65],
    );

    final paint = Paint()
      ..shader = shader
      ..blendMode = BlendMode.lighten;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _ShimmerPainter oldDelegate) => oldDelegate.progress != progress;
}

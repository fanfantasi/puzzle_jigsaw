// widgets/jigsaw/jigsaw_block.dart
import 'package:ai_puzzle/services/config.dart';
import 'package:ai_puzzle/widgets/jigsaw/jigsaw_path_utils.dart';
import 'package:flutter/material.dart';
import 'jigsaw_models.dart';

class JigsawBlockWidget extends StatefulWidget {
  const JigsawBlockWidget({super.key, required this.imageBox, required this.pathType});

  final ImageBox imageBox;
  final JigsawPathType pathType;

  @override
  _JigsawBlockWidgetState createState() => _JigsawBlockWidgetState();
}

class _JigsawBlockWidgetState extends State<JigsawBlockWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: PuzzlePieceClipper(imageBox: widget.imageBox, pathType: widget.pathType),
      child: CustomPaint(
        foregroundPainter: JigsawBlokPainter(imageBox: widget.imageBox, pathType: widget.pathType),
        child: widget.imageBox.image,
      ),
    );
  }
}

class JigsawBlokPainter extends CustomPainter {
  JigsawBlokPainter({required this.imageBox, this.pathType = JigsawPathType.classic});

  final ImageBox imageBox;
  final JigsawPathType pathType;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = imageBox.isDone ? baseColor.withValues(alpha: .5) : Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    final Path path = JigsawPathUtils.getPathByType(pathType, size, imageBox.radiusPoint, imageBox.offsetCenter, imageBox.posSide);

    canvas.drawPath(path, paint);

    if (imageBox.isDone) {
      final Paint paintDone = Paint()
        ..color = baseColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, paintDone);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PuzzlePieceClipper extends CustomClipper<Path> {
  PuzzlePieceClipper({required this.imageBox, this.pathType = JigsawPathType.classic});

  final ImageBox imageBox;
  final JigsawPathType pathType;

  @override
  Path getClip(Size size) {
    return JigsawPathUtils.getPathByType(pathType, size, imageBox.radiusPoint, imageBox.offsetCenter, imageBox.posSide);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

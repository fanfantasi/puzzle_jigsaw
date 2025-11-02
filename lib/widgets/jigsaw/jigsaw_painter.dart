// widgets/jigsaw/jigsaw_painter.dart
import 'package:ai_puzzle/widgets/jigsaw/jigsaw_path_utils.dart';
import 'package:flutter/material.dart';
import '../../services/config.dart';
import 'jigsaw_models.dart';

class JigsawPainterBackground extends CustomPainter {
  JigsawPainterBackground(this.blocks, {required this.outlineCanvas, required this.pathType});

  final List<BlockClass> blocks;
  final bool outlineCanvas;
  final JigsawPathType pathType;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = outlineCanvas ? PaintingStyle.stroke : PaintingStyle.fill
      ..color = baseColor.withValues(alpha: 2)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final Path path = Path();

    for (final element in blocks) {
      final Path pathTemp = JigsawPathUtils.getPathByType(
        pathType,
        element.jigsawBlockWidget.imageBox.size,
        element.jigsawBlockWidget.imageBox.radiusPoint,
        element.jigsawBlockWidget.imageBox.offsetCenter,
        element.jigsawBlockWidget.imageBox.posSide,
      );

      path.addPath(pathTemp, element.offsetDefault);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

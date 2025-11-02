// widgets/jigsaw/jigsaw_models.dart
import 'package:ai_puzzle/widgets/jigsaw/jigsaw_block.dart';
import 'package:ai_puzzle/widgets/jigsaw/jigsaw_path_utils.dart';
import 'package:flutter/material.dart';

class BlockClass {
  BlockClass({required this.offset, required this.jigsawBlockWidget, required this.offsetDefault});

  Offset offset;
  final Offset offsetDefault;
  final JigsawBlockWidget jigsawBlockWidget;
}

class ImageBox {
  ImageBox({
    required this.image,
    required this.posSide,
    required this.isDone,
    required this.offsetCenter,
    required this.radiusPoint,
    required this.size,
  });

  final Widget image;
  final ClassJigsawPos posSide;
  final Offset offsetCenter;
  final Size size;
  final double radiusPoint;
  bool isDone;
}

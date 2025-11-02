import 'dart:async';
import 'dart:typed_data';
import 'package:ai_puzzle/widgets/setting/setting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import '../services/image_service.dart';

class PuzzleProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSolved = false;
  List<Uint8List>? tiles;
  List<int> pieces = [];
  Size? imageSize;
  Uint8List? fullImageBytes;

  Future<Uint8List> _loadAssetBytes(String path) async {
    final data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  Future<void> newPuzzle() async {
    isLoading = true;
    notifyListeners();

    try {
      final imageData = await ImageService().getRandomImage();
      final result = await compute(_processImage, imageData.bytes);

      tiles = result.tiles;
      pieces = result.pieces;
      imageSize = Size(imageData.width.toDouble(), imageData.height.toDouble());
      fullImageBytes = imageData.bytes;
      isSolved = false;
    } catch (e) {
      debugPrint('⚠️ Gagal ambil gambar dari Pixabay: $e');
      debugPrint('➡️ Menggunakan fallback asset image...');

      try {
        final bytes = await _loadAssetBytes('assets/bg-1.jpg');
        final result = await compute(_processImage, bytes);

        tiles = result.tiles;
        pieces = result.pieces;
        imageSize = const Size(800, 800);
        fullImageBytes = bytes;
        isSolved = false;
      } catch (assetError) {
        debugPrint('❌ Gagal load asset fallback: $assetError');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void placePiece(int fromIndex, int toIndex) {
    final newPieces = [...pieces];
    final temp = newPieces[fromIndex];
    newPieces[fromIndex] = newPieces[toIndex];
    newPieces[toIndex] = temp;

    pieces = newPieces;
    isSolved = _checkSolved(newPieces);
    notifyListeners();
  }

  int getTimeLimit(int level) {
    const int baseTime = 30;
    const int increment = 30;
    return baseTime + (level - 2) * increment;
  }

  bool _checkSolved(List<int> pieces) => pieces.every((pieceIndex) => pieceIndex == pieces.indexOf(pieceIndex));

  void showSettingsDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedValue = Curves.elasticOut.transform(anim1.value);
        return Transform.scale(
          scale: curvedValue,
          child: Opacity(
            opacity: anim1.value,
            child: const Center(child: SettingsDialogContent()),
          ),
        );
      },
    );
  }
}

class PuzzleResult {
  final List<Uint8List> tiles;
  final List<int> pieces;

  PuzzleResult(this.tiles, this.pieces);
}

PuzzleResult _processImage(Uint8List bytes) {
  final image = img.decodeImage(bytes)!;
  const gridSize = 6;
  final tileWidth = image.width ~/ gridSize;
  final tileHeight = image.height ~/ gridSize;

  final tiles = <Uint8List>[];

  for (int i = 0; i < gridSize * gridSize; i++) {
    final row = i ~/ gridSize;
    final col = i % gridSize;
    final piece = img.copyCrop(image, x: col * tileWidth, y: row * tileHeight, width: tileWidth, height: tileHeight);
    tiles.add(Uint8List.fromList(img.encodePng(piece)));
  }

  final pieces = List<int>.generate(36, (i) => i)..shuffle();
  return PuzzleResult(tiles, pieces);
}

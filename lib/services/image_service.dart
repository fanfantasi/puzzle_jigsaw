import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:ai_puzzle/services/config.dart';
import 'package:http/http.dart' as http;

class ImageData {
  final Uint8List bytes;
  final int width;
  final int height;

  ImageData({required this.bytes, required this.width, required this.height});
}

class ImageService {
  final _random = math.Random();
  final _queries = [
    "cute animal cartoon illustration",
    "puppy cartoon vector",
    "kitten cartoon kawaii",
    "rabbit cartoon illustration",
    "panda cartoon vector art",
    "lion cartoon character design",
    "fish cartoon clipart",
    "bird cartoon illustration",
    "fruit cartoon cute vector",
    "ice cream cartoon kawaii",
    "cake cartoon illustration",
    "vegetable cartoon character",
    "candy cartoon cute art",
    "unicorn cartoon fantasy illustration",
    "fairy cartoon character design",
    "dinosaur cartoon illustration",
    "space cartoon illustration",
    "planet cartoon vector art",
    "astronaut cartoon illustration",
    "robot cartoon cute vector",
    "monster cartoon illustration",
    "car cartoon illustration",
    "house cartoon vector",
    "rainbow cartoon cute art",
    "ocean animal cartoon illustration",
    "underwater cartoon scene",
  ];

  Future<ImageData> getRandomImage() async {
    try {
      final query = _queries[math.Random().nextInt(_queries.length)];
      print('🔍 Searching for: $query');

      final url =
          "https://pixabay.com/api/?key=$keyPixabay"
          "&q=$query"
          "&image_type=illustration"
          "&orientation=horizontal"
          "&min_width=1000"
          "&per_page=20";

      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) {
        throw Exception("Failed to fetch Pixabay: ${res.statusCode}");
      }

      final data = jsonDecode(res.body);

      final hits = data["hits"] as List;

      if (hits.isEmpty) {
        throw Exception("No image found");
      }

      Map<String, dynamic>? hit;
      for (int i = 0; i < hits.length; i++) {
        final candidate = hits[_random.nextInt(hits.length)];
        final w = candidate["webformatWidth"];
        final h = candidate["webformatHeight"];
        if (w != null && h != null && w > h) {
          hit = candidate;
          break;
        }
      }
      // fallback kalau semua portrait
      hit ??= hits.first;
      final imgUrl = hit!["webformatURL"];
      final width = hit["webformatWidth"];
      final height = hit["webformatHeight"];

      final imgBytes = await http.readBytes(Uri.parse(imgUrl));

      return ImageData(bytes: imgBytes, width: width, height: height);
    } catch (e) {
      rethrow;
    }
  }
}

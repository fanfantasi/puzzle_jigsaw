import 'package:ai_puzzle/services/audio_service.dart';
import 'package:ai_puzzle/services/puzzle_service.dart';
import 'package:ai_puzzle/services/timer_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppDependencies {
  static List<SingleChildWidget> inject() => [
    ChangeNotifierProvider(create: (_) => TimerService()),
    ChangeNotifierProvider(create: (_) => PuzzleProvider()),
    ChangeNotifierProvider(create: (_) => AudioService()),
  ];
}

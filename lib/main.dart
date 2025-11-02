import 'package:ai_puzzle/multi_provider.dart';
import 'package:ai_puzzle/pages/jigsaw_loading.dart';
import 'package:ai_puzzle/widgets/admob/admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Status bar transparan
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparan
      statusBarIconBrightness: Brightness.light, // ikon putih
      systemNavigationBarColor: Colors.black, // nav bar hitam (opsional)
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Paksa portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  MobileAds.instance.initialize();
  AdManager().loadRewardedAd();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppDependencies.inject(),
      child: MaterialApp(
        title: '3D Jigsaw Puzzle',
        debugShowCheckedModeBanner: false,
        builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget!),
          breakpoints: [
            ResponsiveBreakpoint.resize(350, name: MOBILE),
            ResponsiveBreakpoint.autoScale(600, name: TABLET),
            ResponsiveBreakpoint.autoScale(800, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
          ],
        ),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: const AppBarTheme(centerTitle: true, backgroundColor: Colors.deepPurple, foregroundColor: Colors.white, elevation: 2),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
        ),
        home: GradientLoadingScreen(),
      ),
    );
  }
}

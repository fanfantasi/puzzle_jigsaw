import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';

class NativeBannerAdWidget extends StatefulWidget {
  final String unitId;
  const NativeBannerAdWidget({super.key, required this.unitId});

  @override
  State<NativeBannerAdWidget> createState() => _NativeBannerAdWidgetState();
}

class _NativeBannerAdWidgetState extends State<NativeBannerAdWidget> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadNativeAd();
  }

  void _loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: widget.unitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('NativeAd failed to load: $error');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small, // banner gaya kecil
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_isLoaded && _nativeAd != null)
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 80, maxHeight: 120),
            child: AdWidget(ad: _nativeAd!),
          )
        else
          Lottie.asset('assets/lottie/loading.json', width: 100, height: 100, repeat: true),
      ],
    );
  }
}

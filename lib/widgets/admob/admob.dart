import 'package:ai_puzzle/services/config.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  RewardedAd? _rewardedAd;

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: adMobVideo,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          debugPrint('Rewarded Ad Loaded');
        },
        onAdFailedToLoad: (err) {
          debugPrint('Rewarded Ad Failed to Load: $err');
        },
      ),
    );
  }

  void showRewardedAd(VoidCallback onRewarded) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadRewardedAd(); // load lagi untuk berikutnya
        },
        onAdFailedToShowFullScreenContent: (ad, err) {
          ad.dispose();
          loadRewardedAd();
        },
      );

      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          onRewarded(); // beri reward ke user
        },
      );

      _rewardedAd = null; // clear
    } else {
      debugPrint('Rewarded Ad not ready yet');
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();

  factory AdService() {
    return _instance;
  }

  AdService._internal();

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  // Debug: Use test ad IDs to avoid policy violations
  // Release: Use real ad IDs
  final String _interstitialAdUnitId = kDebugMode
      ? 'ca-app-pub-3940256099942544/1033173712'  // Google test interstitial
      : 'ca-app-pub-6698554585648483/3166500913';
  final String _rewardedAdUnitId = kDebugMode
      ? 'ca-app-pub-3940256099942544/5224354917'  // Google test rewarded
      : 'ca-app-pub-6698554585648483/6359640464';

  Future<void> initialize() async {
    if (kIsWeb) return; // Ads not supported on web
    await MobileAds.instance.initialize();
    loadInterstitialAd();
    loadRewardedAd();
  }

  void loadInterstitialAd() {
    if (kIsWeb) return;
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('InterstitialAd loaded.');
          _interstitialAd = ad;
          _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              loadInterstitialAd(); // Load the next one
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd failed to load: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onAdDismissed}) {
    if (kIsWeb) {
      debugPrint("Web Mock: Interstitial ad skipped.");
      if (onAdDismissed != null) onAdDismissed();
      return;
    }

    if (_interstitialAd == null) {
      debugPrint('Warning: attempt to show interstitial before loaded.');
      if (onAdDismissed != null) onAdDismissed();
      loadInterstitialAd(); // Try loading again
      return;
    }
    
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadInterstitialAd();
        if (onAdDismissed != null) onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        loadInterstitialAd();
        if (onAdDismissed != null) onAdDismissed();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null; // Mark as null so it doesn't get shown twice
  }

  void loadRewardedAd() {
    if (kIsWeb) return;
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('RewardedAd loaded.');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('RewardedAd failed to load: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  void showRewardedAd({required VoidCallback onRewardEarned, VoidCallback? onAdFailed}) {
    if (kIsWeb) {
      debugPrint("Web Mock: Rewarding user instantly without ad.");
      onRewardEarned();
      return;
    }

    if (_rewardedAd == null) {
      debugPrint('Warning: attempt to show rewarded before loaded.');
      if (onAdFailed != null) onAdFailed();
      loadRewardedAd();
      return;
    }

    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => debugPrint('Ad showed fullscreen content.'),
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        loadRewardedAd();
        if (onAdFailed != null) onAdFailed();
      },
    );

    _rewardedAd?.setImmersiveMode(true);
    _rewardedAd?.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        onRewardEarned();
      },
    );
    _rewardedAd = null;
  }
}

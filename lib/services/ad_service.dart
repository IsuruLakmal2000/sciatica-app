import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../state/app_state.dart';

class AdService {
  static InterstitialAd? _interstitialAd;
  static bool _isAdLoading = false;
  static DateTime? _lastAdShownTime;

  // Official Google AdMob Interstitial Test Unit IDs
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9764584713102923/7258256068';
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// Initialize the Mobile Ads SDK.
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
    await _loadCooldown();
    _preloadInterstitial();
  }

  /// Load the last shown time from SharedPreferences.
  static Future<void> _loadCooldown() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ms = prefs.getInt('last_ad_shown_time_ms');
      if (ms != null) {
        _lastAdShownTime = DateTime.fromMillisecondsSinceEpoch(ms);
      }
    } catch (e) {
      debugPrint('Error loading ad cooldown: $e');
    }
  }

  /// Update the last shown time in memory and SharedPreferences.
  static Future<void> _updateCooldown() async {
    final now = DateTime.now();
    _lastAdShownTime = now;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_ad_shown_time_ms', now.millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('Error saving ad cooldown: $e');
    }
  }

  /// Check if the 5-minute cooldown is active.
  static bool isCooldownActive() {
    if (_lastAdShownTime == null) return false;
    final diff = DateTime.now().difference(_lastAdShownTime!);
    return diff < const Duration(minutes: 5);
  }

  /// Check if today is a "next day" first open, and consume it.
  static Future<bool> checkAndConsumeNextDayTrigger() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todayStr = DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD
      final lastOpenDateStr = prefs.getString('last_open_date_str');
      final triggerConsumedDateStr = prefs.getString('next_day_trigger_consumed_date_str');

      if (lastOpenDateStr == null) {
        // First time opening the app ever. Setup date, but no next day ad.
        await prefs.setString('last_open_date_str', todayStr);
        return false;
      }

      if (lastOpenDateStr != todayStr) {
        // It's a different calendar day! Check if we already consumed the trigger today.
        if (triggerConsumedDateStr != todayStr) {
          // Trigger not consumed yet today. Update open date and trigger consumed date.
          await prefs.setString('last_open_date_str', todayStr);
          await prefs.setString('next_day_trigger_consumed_date_str', todayStr);
          return true;
        }
        // Already consumed today. Update date anyway.
        await prefs.setString('last_open_date_str', todayStr);
      }
    } catch (e) {
      debugPrint('Error checking next day trigger: $e');
    }
    return false;
  }

  /// Consume the next day trigger so it won't be fired on subsequent actions today.
  static Future<void> consumeNextDayTrigger() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todayStr = DateTime.now().toIso8601String().substring(0, 10);
      await prefs.setString('next_day_trigger_consumed_date_str', todayStr);
      await prefs.setString('last_open_date_str', todayStr);
    } catch (e) {
      debugPrint('Error consuming next day trigger: $e');
    }
  }

  /// Preload an Interstitial Ad so it is ready to be shown instantly.
  static void _preloadInterstitial() {
    if (_isAdLoading || _interstitialAd != null) return;
    _isAdLoading = true;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoading = false;
          debugPrint('Interstitial ad preloaded successfully.');
        },
        onAdFailedToLoad: (error) {
          _isAdLoading = false;
          _interstitialAd = null;
          debugPrint('Failed to load interstitial ad: ${error.message}');
          // Retry loading after a delay
          Future.delayed(const Duration(seconds: 15), () => _preloadInterstitial());
        },
      ),
    );
  }

  /// Show the interstitial ad if premium is inactive and the cooldown has expired.
  /// Returns a boolean indicating whether the ad was shown.
  static Future<bool> showInterstitial(BuildContext context) async {
    final state = AppStateProvider.maybeOf(context);
    
    // 1. Check if user is premium
    if (state != null && state.profile.isPremium) {
      debugPrint('User is premium. Ad showing skipped.');
      return false;
    }

    // 2. Check cooldown
    if (isCooldownActive()) {
      final remaining = const Duration(minutes: 5) - DateTime.now().difference(_lastAdShownTime!);
      debugPrint('Ad cooldown active. Remaining: ${remaining.inSeconds}s. Ad skipped.');
      return false;
    }

    // 3. Ensure ad is loaded
    if (_interstitialAd == null) {
      debugPrint('Interstitial ad not loaded yet. Preloading...');
      _preloadInterstitial();
      return false;
    }

    // 4. Show the ad
    final adToShow = _interstitialAd!;
    _interstitialAd = null; // Clear reference before showing to prevent double-show
    
    adToShow.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        debugPrint('Ad showed full screen.');
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('Ad dismissed full screen.');
        ad.dispose();
        _preloadInterstitial(); // Preload next ad
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Ad failed to show: ${error.message}');
        ad.dispose();
        _preloadInterstitial();
      },
    );

    await adToShow.show();
    await _updateCooldown();
    return true;
  }

  /// Trigger the next-day ad if applicable.
  static Future<void> showNextDayAdIfApplicable(BuildContext context) async {
    final state = AppStateProvider.maybeOf(context);
    if (state != null && state.profile.isPremium) return;

    if (await checkAndConsumeNextDayTrigger()) {
      if (!context.mounted) return;
      await showInterstitial(context);
    }
  }
}

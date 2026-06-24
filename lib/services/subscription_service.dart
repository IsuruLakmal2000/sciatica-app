import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionService {
  static const String _entitlementId = 'premium';

  // Sample API keys (Replace with your actual RevenueCat public API keys)
  static String get apiKey {
    if (Platform.isAndroid) {
      return 'goog_sample_key_sciatica';
    } else if (Platform.isIOS) {
      return 'appl_OsHyAitEOixtXRdyiytHjseyLve';
    }
    throw UnsupportedError('Unsupported platform');
  }

  // Notifier to publish premium status changes reactively to the app
  static final ValueNotifier<bool> isPremiumNotifier = ValueNotifier<bool>(
    false,
  );

  /// Initialize the RevenueCat SDK.
  static Future<void> initialize() async {
    try {
      await Purchases.setLogLevel(LogLevel.debug);

      PurchasesConfiguration configuration = PurchasesConfiguration(apiKey);
      await Purchases.configure(configuration);

      // Fetch initial customer info and check status
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      _updatePremiumStatus(customerInfo);

      // Register listener for real-time purchase updates
      Purchases.addCustomerInfoUpdateListener((customerInfo) {
        _updatePremiumStatus(customerInfo);
      });
      debugPrint('RevenueCat SDK initialized successfully.');
    } catch (e) {
      debugPrint('Error initializing RevenueCat SDK: $e');
    }
  }

  /// Sync active entitlements to our premium notifier.
  static void _updatePremiumStatus(CustomerInfo customerInfo) {
    final active = customerInfo.entitlements.active.containsKey(_entitlementId);
    isPremiumNotifier.value = active;
    debugPrint('RevenueCat premium status updated: $active');
  }

  /// Fetch available offerings from RevenueCat.
  static Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      debugPrint('Error fetching offerings: $e');
      return null;
    }
  }

  /// Purchase a package via RevenueCat.
  static Future<bool> purchasePackage(Package package) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      _updatePremiumStatus(customerInfo);
      return customerInfo.entitlements.active.containsKey(_entitlementId);
    } catch (e) {
      debugPrint('Purchase failed: $e');
      return false;
    }
  }

  /// Restore purchases via RevenueCat.
  static Future<bool> restorePurchases() async {
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      _updatePremiumStatus(customerInfo);
      return customerInfo.entitlements.active.containsKey(_entitlementId);
    } catch (e) {
      debugPrint('Restore failed: $e');
      return false;
    }
  }

  /// Force a manual check of premium status from RevenueCat.
  static Future<bool> checkPremiumStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      _updatePremiumStatus(customerInfo);
      return isPremiumNotifier.value;
    } catch (e) {
      debugPrint('Error checking premium status: $e');
      return isPremiumNotifier.value;
    }
  }
}

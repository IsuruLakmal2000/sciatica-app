import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../services/subscription_service.dart';
import 'legal_document_screen.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _isLoading = false;
  Offerings? _offerings;
  bool _isSandboxMode = false;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    setState(() => _isLoading = true);
    final offerings = await SubscriptionService.getOfferings();
    
    if (mounted) {
      setState(() {
        _offerings = offerings;
        _isLoading = false;
        // Enter sandbox fallback mode if offerings are not configured on the dashboard yet
        if (offerings == null || offerings.current == null || offerings.current!.availablePackages.isEmpty) {
          _isSandboxMode = true;
        }
      });
    }
  }

  Future<void> _handlePurchase(Package? package) async {
    setState(() => _isLoading = true);
    bool success = false;

    if (_isSandboxMode || package == null) {
      final state = AppStateProvider.of(context);
      // Tester Sandbox Mode: Simulate successful purchase
      await Future.delayed(const Duration(milliseconds: 1200));
      await state.setPremiumStatus(true);
      success = true;
    } else {
      // Real Purchase via RevenueCat
      success = await SubscriptionService.purchasePackage(package);
    }

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        _showSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase failed. Please try again.')),
        );
      }
    }
  }

  Future<void> _handleRestore() async {
    setState(() => _isLoading = true);
    final success = await SubscriptionService.restorePurchases();
    
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchases restored successfully!')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No active subscriptions found.')),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1428),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Text('👑 ', style: TextStyle(fontSize: 24)),
            Text(
              'Welcome to Premium',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'Your lifetime premium access is now active. All advertisements have been removed, and unlimited recovery tools are unlocked.',
          style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close dialog
              Navigator.of(context).pop(); // Close paywall
            },
            child: const Text(
              'Get Started',
              style: TextStyle(color: AppColors.burntOrange, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEULA() async {
    final url = Uri.parse('https://www.apple.com/legal/internet-services/itunes/dev/stdeula/');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching EULA: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140E1B), // Deep midnight night purple
      body: Stack(
        children: [
          // Background Gradient decoration
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF221532), // Dark night purple
                    Color(0xFF0F0916), // Pitch black purple
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildMainIllustration(),
                        const SizedBox(height: 24),
                        _buildBenefitsList(),
                        const SizedBox(height: 32),
                        _buildPricingCard(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                _buildFooterLinks(),
              ],
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.burntOrange),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white60, size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            onPressed: _handleRestore,
            child: const Text(
              'Restore',
              style: TextStyle(
                color: Color(0xFFB4A0E8),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainIllustration() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFD4A84A).withAlpha(20),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD4A84A).withAlpha(40), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD4A84A).withAlpha(30),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.star_rounded,
            color: Color(0xFFD4A84A),
            size: 44,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Sciatica Premium',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Accelerate your recovery and stay pain-free',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBenefitsList() {
    final benefits = [
      {
        'icon': Icons.block_flipped,
        'color': AppColors.burntOrange,
        'title': 'No Interruptions (Remove Ads)',
        'desc': 'Stay focused on your daily therapy routines with zero ad breaks.',
      },
      {
        'icon': Icons.all_inclusive_rounded,
        'color': const Color(0xFFB4A0E8),
        'title': 'Unlimited Access',
        'desc': 'Decompress with custom bedtime wind-downs and unlimited pain logging.',
      },
      {
        'icon': Icons.analytics_outlined,
        'color': AppColors.forestGreen,
        'title': 'Continuous Progress Sync',
        'desc': 'Keep your streaks and weekly statistics preserved in the cloud.',
      },
    ];

    return Column(
      children: benefits.map((b) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: (b['color'] as Color).withAlpha(15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(b['icon'] as IconData, color: b['color'] as Color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      b['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      b['desc'] as String,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPricingCard() {
    Package? lifetimePackage;
    String priceDisplay = '\$29.99';

    if (!_isSandboxMode && _offerings?.current != null) {
      // Find Lifetime package in offerings
      final available = _offerings!.current!.availablePackages;
      for (final p in available) {
        if (p.packageType == PackageType.lifetime) {
          lifetimePackage = p;
          priceDisplay = p.storeProduct.priceString;
          break;
        }
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1528),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD4A84A).withAlpha(50), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4A84A).withAlpha(10),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lifetime Access',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'One-time purchase',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4A84A).withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'BEST VALUE',
                  style: TextStyle(
                    color: Color(0xFFD4A84A),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                priceDisplay,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'forever',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => _handlePurchase(lifetimePackage),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.burntOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
                shadowColor: AppColors.burntOrange.withAlpha(60),
              ),
              child: const Text(
                'Unlock Lifetime Access',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (_isSandboxMode) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bug_report_rounded, color: Colors.amber, size: 14),
                  SizedBox(width: 6),
                  Text(
                    'Sandbox Tester Mode Active',
                    style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: _launchEULA,
            child: const Text(
              'Terms of Use',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const Text('|', style: TextStyle(color: Colors.white24, fontSize: 12)),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const LegalDocumentScreen(docType: LegalDocType.privacyPolicy),
                ),
              );
            },
            child: const Text(
              'Privacy Policy',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user_profile.dart';
import '../state/app_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 7;

  // Onboarding data
  final TextEditingController _nameController = TextEditingController();
  String _painLocation = '';
  String _painSeverity = '';
  String _painDuration = '';
  String _mobilityLevel = '';
  final List<String> _otherConditions = [];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  bool get _canProceed {
    switch (_currentPage) {
      case 0:
        return true; // Welcome page
      case 1:
        return _nameController.text.trim().isNotEmpty;
      case 2:
        return _painLocation.isNotEmpty;
      case 3:
        return _painSeverity.isNotEmpty;
      case 4:
        return _painDuration.isNotEmpty;
      case 5:
        return _mobilityLevel.isNotEmpty;
      case 6:
        return true; // Summary page
      default:
        return true;
    }
  }

  Future<void> _completeOnboarding() async {
    final profile = UserProfile(
      name: _nameController.text.trim(),
      painLocation: _painLocation,
      painSeverity: _painSeverity,
      painDuration: _painDuration,
      mobilityLevel: _mobilityLevel,
      otherConditions: _otherConditions,
    );
    final appState = AppStateProvider.of(context);
    await appState.completeOnboarding(profile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.espressoBrown,
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: List.generate(_totalPages, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: index <= _currentPage
                            ? AppColors.burntOrange
                            : AppColors.warmBorder,
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                children: [
                  _buildWelcomePage(),
                  _buildNamePage(),
                  _buildPainLocationPage(),
                  _buildPainSeverityPage(),
                  _buildPainDurationPage(),
                  _buildMobilityPage(),
                  _buildSummaryPage(),
                ],
              ),
            ),
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    GestureDetector(
                      onTap: _previousPage,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.warmBorder),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _canProceed
                            ? () {
                                if (_currentPage == _totalPages - 1) {
                                  _completeOnboarding();
                                } else {
                                  _nextPage();
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canProceed
                              ? AppColors.burntOrange
                              : AppColors.warmBorder,
                          disabledBackgroundColor: AppColors.warmBorder,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          _currentPage == _totalPages - 1
                              ? 'Start Your Journey'
                              : _currentPage == 0
                                  ? 'Get Started'
                                  : 'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _canProceed
                                ? Colors.white
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.burntOrange, AppColors.burntOrangeLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.burntOrange.withAlpha(60),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.healing,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Welcome to\nSciatica Relief',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your personal sciatica recovery companion.\nLet\'s build a plan that works for you.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFeatureChip(Icons.fitness_center, 'Exercises'),
              const SizedBox(width: 12),
              _buildFeatureChip(Icons.trending_up, 'Tracking'),
              const SizedBox(width: 12),
              _buildFeatureChip(Icons.star, 'Gamification'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.warmBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.burntOrange, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNamePage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'What should we\ncall you?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'We\'ll use this to personalise your experience.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
            ),
            decoration: const InputDecoration(
              hintText: 'Your name',
              prefixIcon: Icon(Icons.person_outline, color: AppColors.burntOrange),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildPainLocationPage() {
    return _buildSelectionPage(
      title: 'Where is your\npain?',
      subtitle: 'Select the primary area of discomfort.',
      options: [
        _SelectionOption('left_leg', 'Left Leg', Icons.arrow_back, 'Pain radiating down the left leg'),
        _SelectionOption('right_leg', 'Right Leg', Icons.arrow_forward, 'Pain radiating down the right leg'),
        _SelectionOption('both_legs', 'Both Legs', Icons.swap_horiz, 'Pain in both legs'),
        _SelectionOption('lower_back', 'Lower Back Only', Icons.airline_seat_flat, 'Pain concentrated in the lower back'),
      ],
      selectedValue: _painLocation,
      onSelected: (value) => setState(() => _painLocation = value),
    );
  }

  Widget _buildPainSeverityPage() {
    return _buildSelectionPage(
      title: 'How severe is\nyour pain?',
      subtitle: 'This helps us set the right intensity level.',
      options: [
        _SelectionOption('mild', 'Mild', Icons.sentiment_satisfied, 'Noticeable but manageable'),
        _SelectionOption('moderate', 'Moderate', Icons.sentiment_neutral, 'Affects daily activities'),
        _SelectionOption('severe', 'Severe', Icons.sentiment_very_dissatisfied, 'Significantly limits movement'),
      ],
      selectedValue: _painSeverity,
      onSelected: (value) => setState(() => _painSeverity = value),
    );
  }

  Widget _buildPainDurationPage() {
    return _buildSelectionPage(
      title: 'How long have\nyou had this?',
      subtitle: 'Duration affects your recovery approach.',
      options: [
        _SelectionOption('weeks', 'A few weeks', Icons.calendar_today, 'Less than a month'),
        _SelectionOption('months', 'A few months', Icons.date_range, '1 to 6 months'),
        _SelectionOption('year_plus', 'Over a year', Icons.event_repeat, 'Chronic or recurring'),
      ],
      selectedValue: _painDuration,
      onSelected: (value) => setState(() => _painDuration = value),
    );
  }

  Widget _buildMobilityPage() {
    return _buildSelectionPage(
      title: 'What\'s your\nmobility level?',
      subtitle: 'We\'ll match exercises to your ability.',
      options: [
        _SelectionOption('floor', 'Can get on the floor', Icons.self_improvement, 'Able to do floor exercises'),
        _SelectionOption('chair', 'Chair exercises only', Icons.chair, 'Prefer seated exercises'),
        _SelectionOption('bed', 'Bed exercises only', Icons.bed, 'Currently limited to lying down'),
      ],
      selectedValue: _mobilityLevel,
      onSelected: (value) => setState(() => _mobilityLevel = value),
    );
  }

  Widget _buildSelectionPage({
    required String title,
    required String subtitle,
    required List<_SelectionOption> options,
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 28),
          ...options.map((option) {
            final isSelected = selectedValue == option.value;
            return GestureDetector(
              onTap: () => onSelected(option.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.burntOrange.withAlpha(15)
                      : AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.burntOrange
                        : AppColors.warmBorder,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.burntOrange.withAlpha(30)
                            : AppColors.warmBorder.withAlpha(60),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        option.icon,
                        color: isSelected
                            ? AppColors.burntOrange
                            : AppColors.textSecondary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.label,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (option.description.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              option.description,
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.burntOrange,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            'Your plan is\nready! 🎉',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Here\'s what we\'ve learned about you:',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 28),
          _buildSummaryItem('Name', _nameController.text.trim()),
          _buildSummaryItem('Pain Location', _formatOption(_painLocation)),
          _buildSummaryItem('Severity', _formatOption(_painSeverity)),
          _buildSummaryItem('Duration', _formatOption(_painDuration)),
          _buildSummaryItem('Mobility', _formatOption(_mobilityLevel)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.burntOrange.withAlpha(20),
                  AppColors.warmGold.withAlpha(10),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.burntOrange.withAlpha(40),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppColors.warmGold,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your daily exercises will be personalised based on your answers. Tap "Start Your Journey" to begin!',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warmBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.burntOrange,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatOption(String value) {
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }
}

class _SelectionOption {
  final String value;
  final String label;
  final IconData icon;
  final String description;

  const _SelectionOption(this.value, this.label, this.icon, this.description);
}

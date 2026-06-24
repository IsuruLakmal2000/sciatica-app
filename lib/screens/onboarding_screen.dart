import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user_profile.dart';
import '../state/app_state.dart';
import '../data/exercise_data.dart';
import '../models/exercise.dart';
import '../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 8;
  bool _disclaimerAccepted = false;

  // Onboarding data
  String _painLocation = '';
  String _painSeverity = '';
  String _painDuration = '';
  String _mobilityLevel = '';
  final List<String> _otherConditions = [];

  @override
  void dispose() {
    _pageController.dispose();
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
        return _disclaimerAccepted; // Medical Disclaimer page
      case 2:
        return _painLocation.isNotEmpty;
      case 3:
        return _painSeverity.isNotEmpty;
      case 4:
        return _painDuration.isNotEmpty;
      case 5:
        return _mobilityLevel.isNotEmpty;
      case 6:
        return true; // Preparing Page
      case 7:
        return true; // Summary page
      default:
        return true;
    }
  }

  Future<void> _completeOnboarding() async {
    final profile = UserProfile(
      name: 'Warrior',
      painLocation: _painLocation,
      painSeverity: _painSeverity,
      painDuration: _painDuration,
      mobilityLevel: _mobilityLevel,
      otherConditions: _otherConditions,
    );
    final appState = AppStateProvider.of(context);
    await appState.completeOnboarding(profile);
  }

  void _onPreparingComplete() {
    final exercises = ExerciseData.generateCustomPlan(
      painLocation: _painLocation,
      painSeverity: _painSeverity,
      mobilityLevel: _mobilityLevel,
    );
    final exerciseIds = exercises.map((e) => e.id).toList();
    
    final state = AppStateProvider.of(context);
    state.saveCustomSession(exerciseIds);
    
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
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
                  _buildDisclaimerPage(),
                  _buildPainLocationPage(),
                  _buildPainSeverityPage(),
                  _buildPainDurationPage(),
                  _buildMobilityPage(),
                  _buildPreparingPage(),
                  _buildSummaryPage(),
                ],
              ),
            ),
            // Navigation buttons
            if (_currentPage != 6)
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
                                ? context.l10n('start_journey')
                                : _currentPage == 0
                                    ? context.l10n('get_started')
                                    : context.l10n('continue_btn'),
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

  Widget _buildDisclaimerPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            context.l10n('medical_disclaimer'),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.warmBorder),
            ),
            child: Text(
              context.l10n('disclaimer_content'),
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              setState(() {
                _disclaimerAccepted = !_disclaimerAccepted;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _disclaimerAccepted
                    ? AppColors.burntOrange.withAlpha(15)
                    : AppColors.darkSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _disclaimerAccepted
                      ? AppColors.burntOrange
                      : AppColors.warmBorder,
                  width: _disclaimerAccepted ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _disclaimerAccepted
                            ? AppColors.burntOrange
                            : AppColors.textSecondary,
                        width: 2,
                      ),
                      color: _disclaimerAccepted
                          ? AppColors.burntOrange
                          : Colors.transparent,
                    ),
                    child: _disclaimerAccepted
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.l10n('disclaimer_agree'),
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
            context.l10n('welcome_title'),
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
            context.l10n('welcome_sub'),
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
              _buildFeatureChip(Icons.fitness_center, context.l10n('nav_exercises')),
              const SizedBox(width: 12),
              _buildFeatureChip(Icons.trending_up, context.l10n('trend')),
              const SizedBox(width: 12),
              _buildFeatureChip(Icons.star, context.l10n('earned_badges')),
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



  Widget _buildPainLocationPage() {
    return _buildSelectionPage(
      title: context.l10n('q_location'),
      subtitle: context.l10n('q_location_sub'),
      options: [
        _SelectionOption('left_leg', context.l10n('loc_left_leg'), Icons.arrow_back, context.l10n('loc_left_leg_desc')),
        _SelectionOption('right_leg', context.l10n('loc_right_leg'), Icons.arrow_forward, context.l10n('loc_right_leg_desc')),
        _SelectionOption('both_legs', context.l10n('loc_both_legs'), Icons.swap_horiz, context.l10n('loc_both_legs_desc')),
        _SelectionOption('lower_back', context.l10n('loc_lower_back'), Icons.airline_seat_flat, context.l10n('loc_lower_back_desc')),
      ],
      selectedValue: _painLocation,
      onSelected: (value) => setState(() => _painLocation = value),
    );
  }

  Widget _buildPainSeverityPage() {
    return _buildSelectionPage(
      title: context.l10n('q_severity'),
      subtitle: context.l10n('q_severity_sub'),
      options: [
        _SelectionOption('mild', context.l10n('sev_mild'), Icons.sentiment_satisfied, context.l10n('sev_mild_desc')),
        _SelectionOption('moderate', context.l10n('sev_moderate'), Icons.sentiment_neutral, context.l10n('sev_moderate_desc')),
        _SelectionOption('severe', context.l10n('sev_severe'), Icons.sentiment_very_dissatisfied, context.l10n('sev_severe_desc')),
      ],
      selectedValue: _painSeverity,
      onSelected: (value) => setState(() => _painSeverity = value),
    );
  }

  Widget _buildPainDurationPage() {
    return _buildSelectionPage(
      title: context.l10n('q_duration'),
      subtitle: context.l10n('q_duration_sub'),
      options: [
        _SelectionOption('weeks', context.l10n('dur_weeks'), Icons.calendar_today, context.l10n('dur_weeks_desc')),
        _SelectionOption('months', context.l10n('dur_months'), Icons.date_range, context.l10n('dur_months_desc')),
        _SelectionOption('year_plus', context.l10n('dur_years'), Icons.event_repeat, context.l10n('dur_years_desc')),
      ],
      selectedValue: _painDuration,
      onSelected: (value) => setState(() => _painDuration = value),
    );
  }

  Widget _buildMobilityPage() {
    return _buildSelectionPage(
      title: context.l10n('q_mobility'),
      subtitle: context.l10n('q_mobility_sub'),
      options: [
        _SelectionOption('floor', context.l10n('mob_floor'), Icons.self_improvement, context.l10n('mob_floor_desc')),
        _SelectionOption('chair', context.l10n('mob_chair'), Icons.chair, context.l10n('mob_chair_desc')),
        _SelectionOption('bed', context.l10n('mob_bed'), Icons.bed, context.l10n('mob_bed_desc')),
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

  Widget _buildPreparingPage() {
    return PreparingPlanScreen(
      onComplete: _onPreparingComplete,
    );
  }

  Widget _buildSummaryPage() {
    final state = AppStateProvider.of(context);
    final exercises = state.customSessionExercises;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            context.l10n('summary_ready'),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n('summary_desc'),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 20),
          // Quick recap chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSummaryChip(context.l10n('loc_$_painLocation'), Icons.location_on, AppColors.dangerRedLight),
                const SizedBox(width: 8),
                _buildSummaryChip(context.l10n('sev_$_painSeverity'), Icons.speed, AppColors.warmGold),
                const SizedBox(width: 8),
                _buildSummaryChip(context.l10n('mob_$_mobilityLevel'), Icons.accessibility_new, AppColors.forestGreen),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            context.l10n('todays_routine'),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          if (exercises.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.burntOrange,
                ),
              ),
            )
          else
            ...exercises.map((ex) => _buildPreviewExerciseCard(ex)),
          const SizedBox(height: 20),
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
                Icon(
                  Icons.auto_awesome,
                  color: AppColors.warmGold,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.l10n('summary_footer'),
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewExerciseCard(Exercise ex) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warmBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.burntOrange.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(ex.icon, color: AppColors.burntOrange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ex.getName(context),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 3),
                    Text(
                      ex.durationDisplay,
                      style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.speed, size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 3),
                    Text(
                      ex.getDifficultyDisplay(context),
                      style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ],
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

class PreparingPlanScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const PreparingPlanScreen({super.key, required this.onComplete});

  @override
  State<PreparingPlanScreen> createState() => _PreparingPlanScreenState();
}

class _PreparingPlanScreenState extends State<PreparingPlanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _loadingStep = 0;
  List<String> getSteps(BuildContext context) => [
    context.l10n('prep_analyzing'),
    context.l10n('prep_filtering'),
    context.l10n('prep_structuring'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _startTimer();
  }

  void _startTimer() async {
    for (int i = 0; i < 3; i++) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _loadingStep = (i + 1).clamp(0, 2);
        });
      }
    }
    await Future.delayed(const Duration(milliseconds: 500));
    widget.onComplete();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final scale = 1.0 + (_controller.value * 0.12);
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: AppColors.burntOrange.withAlpha(20),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.burntOrange.withAlpha(80),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.burntOrange.withAlpha(40),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: AppColors.burntOrange,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Text(
              context.l10n('prep_preparing'),
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 20,
              child: Text(
                getSteps(context)[_loadingStep],
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 48),
            Container(
              width: 140,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.warmBorder,
                borderRadius: BorderRadius.circular(2),
              ),
              child: const ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(2)),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.burntOrange),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../models/gamification.dart';
import '../models/exercise.dart';
import '../widgets/pain_score_selector.dart';
import '../widgets/exercise_card.dart';
import '../widgets/stat_card.dart';
import '../models/pain_entry.dart';
import 'session_player_screen.dart';
import 'bedtime_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPainScore = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = AppStateProvider.of(context);
    if (_selectedPainScore == 0 && state.todaysPainScore > 0) {
      _selectedPainScore = state.todaysPainScore;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final gam = state.gamification;
    final exercises = state.todaysExercises;

    return Scaffold(
      backgroundColor: AppColors.espressoBrown,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeroCard(state, gam)),
            SliverToBoxAdapter(child: _buildFlareUpButton(state)),
            SliverToBoxAdapter(child: _buildPainSection(state)),
            SliverToBoxAdapter(child: _buildQuickStats(state, gam)),
            SliverToBoxAdapter(child: _buildSectionTitle('Today\'s Session')),
            SliverToBoxAdapter(
              child: _buildExerciseList(state, exercises),
            ),
            SliverToBoxAdapter(child: _buildStartButton(exercises)),
            SliverToBoxAdapter(child: _buildBedtimeCard()),
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(AppState state, GamificationData gam) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }
    final name = state.profile.name.isNotEmpty ? state.profile.name : 'there';

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.burntOrange, AppColors.burntOrangeLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.burntOrange.withAlpha(60),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting,',
                      style: TextStyle(
                        color: Colors.white.withAlpha(200),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              // Streak badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text(
                      '${gam.currentStreak}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // XP bar on hero card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lv.${gam.currentLevel} ${gam.levelTitle}',
                style: TextStyle(
                  color: Colors.white.withAlpha(220),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${gam.totalXP} / ${gam.xpForNextLevel} XP',
                style: TextStyle(
                  color: Colors.white.withAlpha(180),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: gam.levelProgress,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.warmGold,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.warmGold.withAlpha(80),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Day ${gam.currentStreak > 0 ? gam.currentStreak : 1} of your recovery journey',
            style: TextStyle(
              color: Colors.white.withAlpha(160),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlareUpButton(AppState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: () => state.toggleFlareUpMode(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: state.isFlareUpMode
                ? AppColors.dangerRed.withAlpha(20)
                : AppColors.darkSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: state.isFlareUpMode
                  ? AppColors.dangerRed.withAlpha(80)
                  : AppColors.warmBorder,
              width: state.isFlareUpMode ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: state.isFlareUpMode
                      ? AppColors.dangerRed.withAlpha(30)
                      : AppColors.dangerRed.withAlpha(15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_fire_department,
                  color: state.isFlareUpMode
                      ? AppColors.dangerRed
                      : AppColors.dangerRedLight,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.isFlareUpMode
                          ? 'Flare-Up Mode Active'
                          : 'Flare-Up Mode',
                      style: TextStyle(
                        color: state.isFlareUpMode
                            ? AppColors.dangerRed
                            : AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      state.isFlareUpMode
                          ? 'Showing gentle, bed-friendly exercises only'
                          : 'Tap to switch to gentle exercises only',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                state.isFlareUpMode
                    ? Icons.toggle_on
                    : Icons.toggle_off_outlined,
                color: state.isFlareUpMode
                    ? AppColors.dangerRed
                    : AppColors.textMuted,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPainSection(AppState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.warmBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'How\'s your pain today?',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (state.painTrend > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.forestGreen.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.trending_down,
                        color: AppColors.forestGreen,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Improving',
                        style: TextStyle(
                          color: AppColors.forestGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          PainScoreSelector(
            selectedScore: _selectedPainScore,
            onScoreSelected: (score) {
              setState(() => _selectedPainScore = score);
              // Log the pain entry
              state.logPain(PainEntry(
                date: DateTime.now(),
                painScore: score,
                painLocation: state.profile.painLocation,
              ));
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'No pain',
                style: TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
              Text(
                'Worst pain',
                style: TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(AppState state, GamificationData gam) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              icon: Icons.local_fire_department,
              label: 'Streak',
              value: '${gam.currentStreak}',
              color: AppColors.burntOrange,
              subtitle: 'days',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: StatCard(
              icon: Icons.star_rounded,
              label: 'Total XP',
              value: '${gam.totalXP}',
              color: AppColors.warmGold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: StatCard(
              icon: Icons.check_circle_outline,
              label: 'Today',
              value: '${state.todaysCompletedExercises.length}',
              color: AppColors.forestGreen,
              subtitle: 'done',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildExerciseList(AppState state, List<Exercise> exercises) {
    if (exercises.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.warmBorder),
          ),
          child: const Column(
            children: [
              Icon(Icons.check_circle, color: AppColors.forestGreen, size: 48),
              SizedBox(height: 12),
              Text(
                'All done for today!',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Great job! Come back tomorrow.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: exercises.map<Widget>((exercise) {
          final isCompleted = state.isExerciseCompletedToday(exercise.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ExerciseCard(
              title: exercise.name,
              duration: exercise.durationDisplay,
              category: exercise.categoryDisplay,
              xpReward: exercise.xpReward,
              icon: exercise.icon,
              isCompleted: isCompleted,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SessionPlayerScreen(
                      exercises: [exercise],
                      startIndex: 0,
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStartButton(List<Exercise> exercises) {
    if (exercises.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SessionPlayerScreen(
                  exercises: exercises,
                  startIndex: 0,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.burntOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_arrow_rounded, size: 28, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Start Full Session',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBedtimeCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const BedtimeScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.darkSurface,
                const Color(0xFF1A1520),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.warmBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF3D2D7C).withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.bedtime,
                  color: Color(0xFFB4A0E8),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bedtime Wind-Down',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '5-min routine to decompress before sleep',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
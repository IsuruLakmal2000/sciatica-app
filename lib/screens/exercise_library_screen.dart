import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/exercise_data.dart';
import '../models/exercise.dart';
import 'exercise_detail_screen.dart';
import '../state/app_state.dart';
import '../l10n/app_localizations.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  String _selectedCategory = 'all';
  String _selectedDifficulty = 'all';

  List<Exercise> get _filteredExercises {
    return ExerciseData.allExercises.where((e) {
      final catMatch =
          _selectedCategory == 'all' || e.category == _selectedCategory;
      final diffMatch =
          _selectedDifficulty == 'all' || e.difficulty == _selectedDifficulty;
      return catMatch && diffMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider.of(context);
    return Scaffold(
      backgroundColor: AppColors.espressoBrown,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildCategoryFilters()),
            SliverToBoxAdapter(child: _buildDifficultyFilters()),
            SliverToBoxAdapter(child: const SizedBox(height: 8)),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final exercise = _filteredExercises[index];
                  return _buildExerciseItem(exercise);
                },
                childCount: _filteredExercises.length,
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n('exercise_library'),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n('exercise_library_sub'),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final categories = [
      {'value': 'all', 'label': context.l10n('filter_all'), 'icon': Icons.grid_view_rounded},
      {'value': 'stretch', 'label': context.l10n('filter_stretches'), 'icon': Icons.self_improvement},
      {'value': 'strengthen', 'label': context.l10n('category_strengthen'), 'icon': Icons.fitness_center},
      {'value': 'decompress', 'label': context.l10n('category_decompress'), 'icon': Icons.expand},
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat['value'];
          return GestureDetector(
            onTap: () =>
                setState(() => _selectedCategory = cat['value'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.burntOrange
                    : AppColors.darkSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.burntOrange
                      : AppColors.warmBorder,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    cat['icon'] as IconData,
                    size: 16,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat['label'] as String,
                    style: TextStyle(
                      color:
                          isSelected ? Colors.white : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDifficultyFilters() {
    final difficulties = ['all', 'beginner', 'intermediate', 'advanced'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        children: difficulties.map((diff) {
          final isSelected = _selectedDifficulty == diff;
          final label =
              diff == 'all' ? context.l10n('filter_all_levels') : context.l10n('difficulty_$diff');
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedDifficulty = diff),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.warmGold.withAlpha(20)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.warmGold.withAlpha(60)
                        : AppColors.warmBorder,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.warmGold
                        : AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExerciseItem(Exercise exercise) {
    return GestureDetector(
      onTap: () => _showExerciseDetail(exercise),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.warmBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.burntOrange.withAlpha(15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                exercise.icon,
                color: AppColors.burntOrange,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.getName(context),
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildTag(exercise.getCategoryDisplay(context), AppColors.burntOrange),
                      const SizedBox(width: 6),
                      _buildTag(
                          exercise.getDifficultyDisplay(context), AppColors.warmGold),
                      const SizedBox(width: 6),
                      Icon(Icons.timer_outlined,
                          size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 3),
                      Text(
                        exercise.getDurationDisplay(context),
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (exercise.flareUpFriendly)
                        _buildSmallBadge(context.l10n('flare_up_safe'), AppColors.forestGreen),
                      if (exercise.bedFriendly)
                        _buildSmallBadge(context.l10n('bed_friendly'), const Color(0xFFB4A0E8)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warmGold.withAlpha(15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${exercise.xpReward}XP',
                style: TextStyle(
                  color: AppColors.warmGold,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSmallBadge(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showExerciseDetail(Exercise exercise) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExerciseDetailScreen(exercise: exercise),
      ),
    );
  }
}

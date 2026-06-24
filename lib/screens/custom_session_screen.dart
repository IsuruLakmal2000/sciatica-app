import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/exercise.dart';
import '../data/exercise_data.dart';
import '../state/app_state.dart';
import '../l10n/app_localizations.dart';

class CustomSessionScreen extends StatefulWidget {
  const CustomSessionScreen({super.key});

  @override
  State<CustomSessionScreen> createState() => _CustomSessionScreenState();
}

class _CustomSessionScreenState extends State<CustomSessionScreen> {
  final List<String> _selectedExerciseIds = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = AppStateProvider.of(context);
      setState(() {
        _selectedExerciseIds.addAll(state.customSessionExerciseIds);
      });
    });
  }

  void _toggleExercise(String id) {
    setState(() {
      if (_selectedExerciseIds.contains(id)) {
        _selectedExerciseIds.remove(id);
      } else {
        _selectedExerciseIds.add(id);
      }
    });
  }

  int _calculateTotalDuration() {
    int total = 0;
    for (final id in _selectedExerciseIds) {
      final ex = ExerciseData.allExercises.firstWhere((e) => e.id == id, orElse: () => ExerciseData.allExercises.first);
      total += ex.durationSeconds;
    }
    return total ~/ 60;
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final totalDurationMins = _calculateTotalDuration();

    // Group exercises by category
    final Map<String, List<Exercise>> grouped = {
      'stretch': ExerciseData.getByCategory('stretch'),
      'strengthen': ExerciseData.getByCategory('strengthen'),
      'decompress': ExerciseData.getByCategory('decompress'),
    };

    return Scaffold(
      backgroundColor: AppColors.espressoBrown,
      appBar: AppBar(
        backgroundColor: AppColors.espressoBrown,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          context.l10n('customize_session'),
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (_selectedExerciseIds.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedExerciseIds.clear();
                });
              },
              child: Text(
                context.l10n('clear_all'),
                style: const TextStyle(
                  color: AppColors.burntOrange,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Header Summary Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.warmBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.burntOrange.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.tune_rounded, color: AppColors.burntOrange, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n('exercises_selected', [_selectedExerciseIds.length.toString()]),
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n('total_duration_mins', [totalDurationMins.toString()]),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                _buildCategorySection(context.l10n('category_stretches'), grouped['stretch'] ?? [], Colors.teal),
                const SizedBox(height: 20),
                _buildCategorySection(context.l10n('category_strengthening'), grouped['strengthen'] ?? [], AppColors.burntOrange),
                const SizedBox(height: 20),
                _buildCategorySection(context.l10n('category_decompression'), grouped['decompress'] ?? [], AppColors.warmGold),
                const SizedBox(height: 100), // padding for floating action button
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: AppColors.espressoBrown,
          border: Border(
            top: BorderSide(color: AppColors.warmBorder, width: 1),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () {
              state.saveCustomSession(_selectedExerciseIds);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.burntOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: AppColors.burntOrange.withAlpha(60),
            ),
            child: Text(
              _selectedExerciseIds.isEmpty ? context.l10n('cancel_exit') : context.l10n('save_custom_session'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Exercise> exercises, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: accentColor.withAlpha(50),
                shape: BoxShape.circle,
                border: Border.all(color: accentColor, width: 2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...exercises.map((exercise) {
          final isSelected = _selectedExerciseIds.contains(exercise.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () => _toggleExercise(exercise.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.darkSurface
                      : AppColors.darkSurface.withAlpha(180),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.burntOrange
                        : AppColors.warmBorder,
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.burntOrange.withAlpha(10),
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    // Icon placeholder
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.burntOrange.withAlpha(25)
                            : AppColors.warmBorder.withAlpha(60),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        exercise.icon,
                        color: isSelected
                            ? AppColors.burntOrange
                            : AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Title and duration
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise.getName(context),
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.timer_outlined, size: 12, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                exercise.getDurationDisplay(context),
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(Icons.speed, size: 12, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                exercise.getDifficultyDisplay(context),
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Selection indicator
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.burntOrange : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.burntOrange : AppColors.textMuted.withAlpha(120),
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 14)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

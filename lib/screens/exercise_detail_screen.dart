import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/exercise.dart';
import 'session_player_screen.dart';
import '../widgets/exercise_animation_player.dart';
import '../state/app_state.dart';
import '../l10n/app_localizations.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    AppStateProvider.of(context);
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
          context.l10n('exercise_details'),
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            child: _buildOverlayBadge(exercise.getCategoryDisplay(context), AppColors.burntOrange),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagePlaceholder(context, exercise),
            _buildTitleSection(context, exercise),
            _buildMetaGrid(context, exercise),
            _buildInstructionsSection(context, exercise),
            _buildCommonMistakesSection(context, exercise),
            _buildModificationsSection(context, exercise),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: _buildStickyBottomButton(context, exercise),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context, Exercise exercise) {
    if (exercise.imageAssets.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Stack(
          children: [
            ExerciseAnimationPlayer(
              imageAssets: exercise.imageAssets,
              height: 220,
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Row(
                children: [
                  if (exercise.flareUpFriendly)
                    _buildOverlayBadge(context.l10n('flare_up_safe'), AppColors.forestGreen),
                  if (exercise.bedFriendly) ...[
                    const SizedBox(width: 6),
                    _buildOverlayBadge(context.l10n('bed_friendly'), const Color(0xFFB4A0E8)),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.warmBorder, width: 1.5),
        gradient: LinearGradient(
          colors: [
            AppColors.darkSurface,
            AppColors.espressoBrown,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.burntOrange.withAlpha(8),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Grid pattern overlay for a premium look
          Positioned.fill(
            child: CustomPaint(
              painter: GridPatternPainter(),
            ),
          ),
          // Stylized glowing light in the center
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.burntOrange.withAlpha(10),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          // Exercise icon with circular frame
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.burntOrange.withAlpha(50),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.burntOrange.withAlpha(15),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    exercise.icon,
                    color: AppColors.burntOrange,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warmBorder.withAlpha(60),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    context.l10n('exercise_demonstration'),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Floating environment labels overlaying the placeholder
          Positioned(
            top: 16,
            right: 16,
            child: Row(
              children: [
                if (exercise.flareUpFriendly)
                  _buildOverlayBadge(context.l10n('flare_up_safe'), AppColors.forestGreen),
                if (exercise.bedFriendly) ...[
                  const SizedBox(width: 6),
                  _buildOverlayBadge(context.l10n('bed_friendly'), const Color(0xFFB4A0E8)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(60), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context, Exercise exercise) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  exercise.getName(context),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.warmGold.withAlpha(15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.warmGold.withAlpha(40)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 14, color: AppColors.warmGold),
                    const SizedBox(width: 4),
                    Text(
                      '${exercise.xpReward} XP',
                      style: TextStyle(
                        color: AppColors.warmGold,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            exercise.getDescription(context),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaGrid(BuildContext context, Exercise exercise) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildMetaCard(
              Icons.timer_outlined,
              context.l10n('duration_label'),
              exercise.getDurationDisplay(context),
              AppColors.burntOrange,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildMetaCard(
              Icons.repeat_rounded,
              context.l10n('sets_label'),
              context.l10n('sets_count', [exercise.sets.toString()]),
              AppColors.burntOrange,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildMetaCard(
              Icons.hourglass_bottom_rounded,
              context.l10n('hold_time_label'),
              context.l10n('hold_seconds_count', [exercise.holdSeconds.toString()]),
              AppColors.warmGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warmBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection(BuildContext context, Exercise exercise) {
    final instructions = exercise.getInstructions(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            children: [
              const Icon(Icons.format_list_numbered_rounded, color: AppColors.burntOrange, size: 20),
              const SizedBox(width: 8),
              Text(
                context.l10n('instructions'),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...instructions.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final step = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.burntOrange.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: const TextStyle(
                          color: AppColors.burntOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCommonMistakesSection(BuildContext context, Exercise exercise) {
    final mistakes = exercise.getCommonMistakes(context);
    if (mistakes.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.dangerRed.withAlpha(30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.dangerRed.withAlpha(5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.dangerRedLight, size: 20),
              const SizedBox(width: 8),
              Text(
                context.l10n('common_mistakes'),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...mistakes.map((mistake) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(Icons.close_rounded, color: AppColors.dangerRedLight, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      mistake,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildModificationsSection(BuildContext context, Exercise exercise) {
    final mods = exercise.getModifications(context);
    if (mods.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.warmGold.withAlpha(30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.warmGold.withAlpha(5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune_rounded, color: AppColors.warmGold, size: 20),
              const SizedBox(width: 8),
              Text(
                context.l10n('modifications'),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...mods.map((modification) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(Icons.info_outline_rounded, color: AppColors.warmGold, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      modification,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStickyBottomButton(BuildContext context, Exercise exercise) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.espressoBrown,
        border: Border(
          top: BorderSide(color: AppColors.warmBorder, width: 1),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SessionPlayerScreen(
                  exercises: [exercise],
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.burntOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            shadowColor: AppColors.burntOrange.withAlpha(60),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                context.l10n('start_exercise'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.warmBorder.withAlpha(15)
      ..strokeWidth = 1;

    const double step = 20;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double j = 0; j < size.height; j += step) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

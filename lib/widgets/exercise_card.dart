import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ExerciseCard extends StatelessWidget {
  final String title;
  final String duration;
  final String category;
  final int xpReward;
  final IconData icon;
  final bool isCompleted;
  final VoidCallback? onTap;

  const ExerciseCard({
    super.key,
    required this.title,
    required this.duration,
    this.category = '',
    this.xpReward = 10,
    required this.icon,
    this.isCompleted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? AppColors.forestGreen.withAlpha(80)
                : AppColors.warmBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Exercise icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.forestGreen.withAlpha(30)
                    : AppColors.burntOrange.withAlpha(20),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isCompleted ? Icons.check_rounded : icon,
                color: isCompleted
                    ? AppColors.forestGreen
                    : AppColors.burntOrange,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            // Title and meta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isCompleted
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 13,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        duration,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (category.isNotEmpty) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.burntOrange.withAlpha(15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            category,
                            style: const TextStyle(
                              color: AppColors.burntOrange,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // XP reward
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.forestGreen.withAlpha(20)
                    : AppColors.warmGold.withAlpha(15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCompleted ? Icons.check : Icons.star_rounded,
                    size: 14,
                    color: isCompleted
                        ? AppColors.forestGreen
                        : AppColors.warmGold,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${xpReward}XP',
                    style: TextStyle(
                      color: isCompleted
                          ? AppColors.forestGreen
                          : AppColors.warmGold,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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
}
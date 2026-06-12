import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BadgeCard extends StatelessWidget {
  final String name;
  final String description;
  final String icon; // emoji
  final bool isEarned;

  const BadgeCard({
    super.key,
    required this.name,
    required this.description,
    required this.icon,
    required this.isEarned,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isEarned ? AppColors.darkSurface : AppColors.darkSurface.withAlpha(120),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEarned ? AppColors.warmGold.withAlpha(80) : AppColors.warmBorder,
          width: 1,
        ),
        boxShadow: isEarned
            ? [
                BoxShadow(
                  color: AppColors.warmGold.withAlpha(20),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                icon,
                style: TextStyle(
                  fontSize: 32,
                  color: isEarned ? null : Colors.grey,
                ),
              ),
              if (!isEarned)
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.espressoBrown.withAlpha(180),
                  ),
                  child: const Icon(
                    Icons.lock,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              color: isEarned ? AppColors.textPrimary : AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: TextStyle(
              color: isEarned ? AppColors.textSecondary : AppColors.textMuted,
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

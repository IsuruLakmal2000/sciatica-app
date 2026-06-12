import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class XpBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final int currentXP;
  final int targetXP;
  final String levelTitle;
  final int level;
  final bool showLabel;
  final double height;

  const XpBar({
    super.key,
    required this.progress,
    required this.currentXP,
    required this.targetXP,
    this.levelTitle = '',
    this.level = 1,
    this.showLabel = true,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Level $level — $levelTitle',
                  style: TextStyle(
                    color: AppColors.warmGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '$currentXP / $targetXP XP',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.warmBorder,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                width: double.infinity,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height / 2),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.warmGoldDark,
                          AppColors.warmGold,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.warmGold.withAlpha(60),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

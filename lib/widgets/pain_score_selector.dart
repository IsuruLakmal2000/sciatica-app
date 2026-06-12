import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PainScoreSelector extends StatelessWidget {
  final int selectedScore;
  final ValueChanged<int> onScoreSelected;

  const PainScoreSelector({
    super.key,
    required this.selectedScore,
    required this.onScoreSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(10, (index) {
        final score = index + 1;
        final isSelected = score == selectedScore;
        final color = AppColors.painScoreColor(score);

        return GestureDetector(
          onTap: () => onScoreSelected(score),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSelected ? 36 : 30,
            height: isSelected ? 36 : 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? color : color.withAlpha(40),
              border: Border.all(
                color: isSelected ? color : color.withAlpha(80),
                width: isSelected ? 2.5 : 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withAlpha(100),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                '$score',
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontSize: isSelected ? 14 : 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

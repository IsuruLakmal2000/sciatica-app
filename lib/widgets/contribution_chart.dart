import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/exercise.dart';

class ExerciseContributionChart extends StatefulWidget {
  final List<CompletedExercise> completedExercises;
  final int currentStreak;
  final int longestStreak;

  const ExerciseContributionChart({
    super.key,
    required this.completedExercises,
    required this.currentStreak,
    required this.longestStreak,
  });

  @override
  State<ExerciseContributionChart> createState() => _ExerciseContributionChartState();
}

class _ExerciseContributionChartState extends State<ExerciseContributionChart> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // First and last day of the current month
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final totalDays = lastDayOfMonth.day;

    // Sunday is row 0, Monday is row 1, ..., Saturday is row 6
    final startOffset = firstDayOfMonth.weekday % 7;
    final totalCells = startOffset + totalDays;
    final numRows = (totalCells / 7).ceil();

    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final currentMonthName = monthNames[now.month - 1];

    // Count completions for each day of this month
    final Map<int, int> completionsByDay = {};
    for (final completion in widget.completedExercises) {
      if (completion.completedAt.year == now.year &&
          completion.completedAt.month == now.month) {
        final day = completion.completedAt.day;
        completionsByDay[day] = (completionsByDay[day] ?? 0) + 1;
      }
    }

    final selectedDate = _selectedDate ?? now;
    final isSelectedMonth = selectedDate.year == now.year && selectedDate.month == now.month;
    final selectedDayCompletions = isSelectedMonth ? (completionsByDay[selectedDate.day] ?? 0) : 0;

    final weekdayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.warmBorder : AppColors.sandyCreamDark,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header title & streak pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Workout Activity',
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimary : const Color(0xFF2D1A0E),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$currentMonthName ${now.year}',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.burntOrange.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.burntOrange.withAlpha(50),
                  ),
                ),
                child: Row(
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.currentStreak} d streak',
                      style: const TextStyle(
                        color: AppColors.burntOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Weekday label headers row
          Row(
            children: weekdayLabels.map((label) {
              return Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // Calendar weeks grid
          Column(
            children: List.generate(numRows, (rowIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  children: List.generate(7, (colIndex) {
                    final cellIndex = rowIndex * 7 + colIndex;
                    final day = cellIndex - startOffset + 1;

                    if (day < 1 || day > totalDays) {
                      return const Expanded(
                        child: SizedBox(
                          height: 30,
                        ),
                      );
                    }

                    final date = DateTime(now.year, now.month, day);
                    final count = completionsByDay[day] ?? 0;
                    final isSelected = _selectedDate != null && _isSameDay(date, _selectedDate!);
                    final isToday = _isSameDay(date, now);

                    return Expanded(
                      child: Center(
                        child: _buildGridCell(date, day, count, isSelected, isToday, isDark),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Footer info and legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _buildSelectionDetail(selectedDate, selectedDayCompletions, now),
              ),
              const SizedBox(width: 10),
              _buildLegend(isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridCell(
    DateTime date,
    int day,
    int count,
    bool isSelected,
    bool isToday,
    bool isDark,
  ) {
    Color cellColor;
    Color textColor;

    if (count == 0) {
      cellColor = isDark
          ? AppColors.warmBorder.withAlpha(120)
          : AppColors.sandyCreamDark;
      textColor = AppColors.textMuted;
    } else {
      textColor = Colors.white;
      if (count == 1) {
        cellColor = AppColors.burntOrange.withAlpha(64);
      } else if (count == 2) {
        cellColor = AppColors.burntOrange.withAlpha(128);
      } else if (count == 3) {
        cellColor = AppColors.burntOrange.withAlpha(191);
      } else {
        cellColor = AppColors.burntOrange;
      }
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: cellColor,
          borderRadius: BorderRadius.circular(6),
          border: isSelected
              ? Border.all(
                  color: isDark ? Colors.white : const Color(0xFF2D1A0E),
                  width: 2,
                )
              : isToday
                  ? Border.all(
                      color: AppColors.burntOrangeLight,
                      width: 1.5,
                    )
                  : null,
        ),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionDetail(DateTime date, int count, DateTime now) {
    final isToday = _isSameDay(date, now);
    final isFuture = date.isAfter(now);

    String msg;
    if (isFuture) {
      msg = '${_formatDate(date)} (Future day)';
    } else if (isToday) {
      msg = count == 0
          ? 'Today: No exercises completed yet.'
          : 'Today: $count exercise${count > 1 ? 's' : ''} completed! 🔥';
    } else {
      msg = count == 0
          ? '${_formatDate(date)}: No exercises completed.'
          : '${_formatDate(date)}: $count exercise${count > 1 ? 's' : ''} completed.';
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Container(
        key: ValueKey(msg),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.burntOrange.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.burntOrange.withAlpha(38),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              count > 0 ? Icons.check_circle_outline : Icons.info_outline,
              color: count > 0 ? AppColors.forestGreen : AppColors.textSecondary,
              size: 14,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                msg,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(bool isDark) {
    final labelStyle = TextStyle(
      color: AppColors.textMuted,
      fontSize: 9,
      fontWeight: FontWeight.w500,
    );

    Widget legendCell(Color color) {
      return Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.symmetric(horizontal: 1.5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      );
    }

    final emptyColor = isDark
        ? AppColors.warmBorder.withAlpha(120)
        : AppColors.sandyCreamDark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Less', style: labelStyle),
        const SizedBox(width: 3),
        legendCell(emptyColor),
        legendCell(AppColors.burntOrange.withAlpha(64)),
        legendCell(AppColors.burntOrange.withAlpha(128)),
        legendCell(AppColors.burntOrange.withAlpha(191)),
        legendCell(AppColors.burntOrange),
        const SizedBox(width: 3),
        Text('More', style: labelStyle),
      ],
    );
  }
}

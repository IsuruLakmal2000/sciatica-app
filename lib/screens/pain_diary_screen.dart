import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../models/pain_entry.dart';
import '../widgets/pain_score_selector.dart';
import '../widgets/contribution_chart.dart';
import '../l10n/app_localizations.dart';

class PainDiaryScreen extends StatefulWidget {
  const PainDiaryScreen({super.key});

  @override
  State<PainDiaryScreen> createState() => _PainDiaryScreenState();
}

class _PainDiaryScreenState extends State<PainDiaryScreen> {
  final Set<String> _expandedMonths = {};
  bool _hasInitializedExpandedMonths = false;

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);

    return Scaffold(
      backgroundColor: AppColors.espressoBrown,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildInsightCards(state)),
            SliverToBoxAdapter(
              child: ExerciseContributionChart(
                completedExercises: state.completedExercises,
                currentStreak: state.gamification.currentStreak,
                longestStreak: state.gamification.longestStreak,
              ),
            ),
            SliverToBoxAdapter(child: _buildTrendGraph(state)),
            SliverToBoxAdapter(child: _buildSectionTitle(context.l10n('history'))),
            if (state.painEntries.isEmpty)
              SliverToBoxAdapter(child: _buildEmptyState())
            else
              SliverToBoxAdapter(
                child: _buildGroupedHistory(state),
              ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showLogPainSheet(context, state),
        backgroundColor: AppColors.burntOrange,
        child: const Icon(Icons.add, color: Colors.white),
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
            context.l10n('pain_diary'),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n('pain_diary_sub'),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCards(AppState state) {
    final entries = state.painEntries;
    if (entries.isEmpty) return const SizedBox.shrink();

    final now = DateTime.now();
    final last7 = entries
        .where((e) => now.difference(e.date).inDays <= 7)
        .toList();
    final avgWeek = last7.isNotEmpty
        ? (last7.fold(0, (sum, e) => sum + e.painScore) / last7.length)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildInsightCard(
              context.l10n('weekly_avg'),
              avgWeek.toStringAsFixed(1),
              AppColors.burntOrange,
              Icons.analytics_outlined,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildInsightCard(
              context.l10n('entries'),
              '${entries.length}',
              AppColors.warmGold,
              Icons.edit_note,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildInsightCard(
              context.l10n('trend'),
              state.painTrend > 0
                  ? '↓ ${state.painTrend.toStringAsFixed(1)}'
                  : state.painTrend < 0
                      ? '↑ ${(-state.painTrend).toStringAsFixed(1)}'
                      : '--',
              state.painTrend > 0
                  ? AppColors.forestGreen
                  : state.painTrend < 0
                      ? AppColors.dangerRed
                      : AppColors.textMuted,
              state.painTrend > 0
                  ? Icons.trending_down
                  : state.painTrend < 0
                      ? Icons.trending_up
                      : Icons.trending_flat,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(
      String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warmBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendGraph(AppState state) {
    final entries = state.painEntries;
    if (entries.length < 2) return const SizedBox.shrink();

    // Take last 14 entries for the graph
    final graphEntries = entries.take(14).toList().reversed.toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warmBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n('trend'),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: CustomPaint(
              size: const Size(double.infinity, 140),
              painter: _PainGraphPainter(graphEntries),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(graphEntries.first.date),
                style: TextStyle(
                    color: AppColors.textMuted, fontSize: 10),
              ),
              Text(
                _formatDate(graphEntries.last.date),
                style: TextStyle(
                    color: AppColors.textMuted, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Map<String, List<PainEntry>> get _groupedPainEntries {
    final Map<String, List<PainEntry>> groups = {};
    final state = AppStateProvider.of(context);
    final months = [
      context.l10n('mon_jan'),
      context.l10n('mon_feb'),
      context.l10n('mon_mar'),
      context.l10n('mon_apr'),
      context.l10n('mon_may'),
      context.l10n('mon_jun'),
      context.l10n('mon_jul'),
      context.l10n('mon_aug'),
      context.l10n('mon_sep'),
      context.l10n('mon_oct'),
      context.l10n('mon_nov'),
      context.l10n('mon_dec'),
    ];

    for (final entry in state.painEntries) {
      final key = '${months[entry.date.month - 1]} ${entry.date.year}';
      if (!groups.containsKey(key)) {
        groups[key] = [];
      }
      groups[key]!.add(entry);
    }
    return groups;
  }

  Widget _buildGroupedHistory(AppState state) {
    final grouped = _groupedPainEntries;
    if (grouped.isEmpty) {
      return const SizedBox.shrink();
    }

    // Expand the most recent month by default once
    if (!_hasInitializedExpandedMonths && grouped.isNotEmpty) {
      _expandedMonths.add(grouped.keys.first);
      _hasInitializedExpandedMonths = true;
    }

    return Column(
      children: grouped.entries.map((entry) {
        final monthKey = entry.key;
        final list = entry.value;

        // Calculate stats for this month
        final count = list.length;
        final avgPain = list.fold(0.0, (sum, e) => sum + e.painScore) / count;
        
        // Find most common trigger in this month
        final triggerCounts = <String, int>{};
        for (final item in list) {
          for (final trigger in item.triggers) {
            triggerCounts[trigger] = (triggerCounts[trigger] ?? 0) + 1;
          }
        }
        String topTrigger = '';
        int maxCount = 0;
        triggerCounts.forEach((trigger, count) {
          if (count > maxCount) {
            maxCount = count;
            topTrigger = trigger;
          }
        });

        return _buildMonthlyExpansionCard(monthKey, list, avgPain, count, topTrigger);
      }).toList(),
    );
  }

  Widget _buildMonthlyExpansionCard(
    String monthKey,
    List<PainEntry> entries,
    double avgPain,
    int count,
    String topTrigger,
  ) {
    final isExpanded = _expandedMonths.contains(monthKey);
    final avgPainColor = AppColors.painScoreColor(avgPain.round());

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warmBorder),
      ),
      child: Column(
        children: [
          // Header Row
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedMonths.remove(monthKey);
                } else {
                  _expandedMonths.add(monthKey);
                }
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Month Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          monthKey,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '$count ${context.l10n('logs')}',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (topTrigger.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 3,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: AppColors.textMuted,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  '${context.l10n('trigger')}: ${_getLocalizedTrigger(context, topTrigger)}',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Monthly Average Pain Score
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: avgPainColor.withAlpha(15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: avgPainColor.withAlpha(40)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${context.l10n('avg')}: ',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          avgPain.toStringAsFixed(1),
                          style: TextStyle(
                            color: avgPainColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          // Expanded Items List
          if (isExpanded) ...[
            Divider(height: 1, color: AppColors.warmBorder),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return _buildSubHistoryItem(entries[index]);
              },
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildSubHistoryItem(PainEntry entry) {
    final color = AppColors.painScoreColor(entry.painScore);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Small round badge for pain score
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withAlpha(40)),
            ),
            child: Center(
              child: Text(
                '${entry.painScore}',
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDateFull(entry.date),
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (entry.painLocation.isNotEmpty)
                      Text(
                        _formatOption(context, entry.painLocation),
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                if (entry.triggers.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: entry.triggers.map((t) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.warmBorder.withAlpha(60),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getLocalizedTrigger(context, t),
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 9,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                if (entry.notes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    entry.notes,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatOption(BuildContext context, String value) {
    if (value.isEmpty) return '';
    final key = 'loc_$value';
    final translated = context.l10n(key);
    if (translated != key) return translated;
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .map(
            (w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.edit_note, color: AppColors.textMuted, size: 48),
          const SizedBox(height: 12),
          Text(
            context.l10n('no_entries'),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n('no_entries_sub'),
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }

  void _showLogPainSheet(BuildContext context, AppState state) {
    int score = 5;
    String location = state.profile.painLocation;
    final selectedTriggers = <String>[];
    final notesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          height: MediaQuery.of(ctx).size.height * 0.8,
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.warmBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n('log_pain'),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n('pain_score'),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              PainScoreSelector(
                selectedScore: score,
                onScoreSelected: (s) => setSheetState(() => score = s),
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n('what_triggered'),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PainEntry.availableTriggers.map((trigger) {
                  final isSelected = selectedTriggers.contains(trigger);
                  return GestureDetector(
                    onTap: () {
                      setSheetState(() {
                        if (isSelected) {
                          selectedTriggers.remove(trigger);
                        } else {
                          selectedTriggers.add(trigger);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.burntOrange.withAlpha(20)
                            : AppColors.espressoBrown,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.burntOrange
                              : AppColors.warmBorder,
                        ),
                      ),
                      child: Text(
                        _getLocalizedTrigger(context, trigger),
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.burntOrange
                              : AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n('notes_optional'),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: notesController,
                maxLines: 3,
                style: TextStyle(
                    color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: context.l10n('notes_hint'),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    state.logPain(PainEntry(
                      date: DateTime.now(),
                      painScore: score,
                      painLocation: location,
                      triggers: selectedTriggers,
                      notes: notesController.text.trim(),
                    ));
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    context.l10n('save_entry'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      context.l10n('mon_jan'),
      context.l10n('mon_feb'),
      context.l10n('mon_mar'),
      context.l10n('mon_apr'),
      context.l10n('mon_may'),
      context.l10n('mon_jun'),
      context.l10n('mon_jul'),
      context.l10n('mon_aug'),
      context.l10n('mon_sep'),
      context.l10n('mon_oct'),
      context.l10n('mon_nov'),
      context.l10n('mon_dec'),
    ];
    final m = months[date.month - 1];
    final shortMonth = m.length > 3 ? m.substring(0, 3) : m;
    return '$shortMonth ${date.day}';
  }

  String _formatDateFull(DateTime date) {
    final months = [
      context.l10n('mon_jan'),
      context.l10n('mon_feb'),
      context.l10n('mon_mar'),
      context.l10n('mon_apr'),
      context.l10n('mon_may'),
      context.l10n('mon_jun'),
      context.l10n('mon_jul'),
      context.l10n('mon_aug'),
      context.l10n('mon_sep'),
      context.l10n('mon_oct'),
      context.l10n('mon_nov'),
      context.l10n('mon_dec'),
    ];
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return context.l10n('today_capitalized');
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return context.l10n('yesterday');
    }
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _getLocalizedTrigger(BuildContext context, String trigger) {
    final key = 'trigger_${trigger.toLowerCase().replaceAll(' ', '_')}';
    final translated = context.l10n(key);
    if (translated != key) return translated;
    return trigger;
  }
}

class _PainGraphPainter extends CustomPainter {
  final List<PainEntry> entries;

  _PainGraphPainter(this.entries);

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.burntOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final dotPaint = Paint()
      ..color = AppColors.burntOrange
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = AppColors.warmBorder.withAlpha(40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw horizontal grid lines
    for (int i = 0; i <= 10; i += 2) {
      final y = size.height - (i / 10 * size.height);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw line graph
    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < entries.length; i++) {
      final x = entries.length == 1
          ? size.width / 2
          : (i / (entries.length - 1)) * size.width;
      final y = size.height - (entries[i].painScore / 10 * size.height);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // Draw dots
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
      canvas.drawCircle(
        Offset(x, y),
        6,
        Paint()
          ..color = AppColors.burntOrange.withAlpha(30)
          ..style = PaintingStyle.fill,
      );
    }

    canvas.drawPath(path, paint);

    // Draw fill gradient
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.burntOrange.withAlpha(40),
          AppColors.burntOrange.withAlpha(5),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _PainGraphPainter oldDelegate) {
    return entries.length != oldDelegate.entries.length;
  }
}

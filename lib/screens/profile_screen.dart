import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../models/gamification.dart';
import '../widgets/xp_bar.dart';
import '../widgets/badge_card.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final gam = state.gamification;

    return Scaffold(
      backgroundColor: AppColors.espressoBrown,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_rounded, color: AppColors.textPrimary, size: 24),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(state, gam),
              _buildXPSection(gam),
              _buildStreakSection(gam),
              _buildWeeklyChallenge(state),
              _buildBadgesSection(gam),
              _buildStatsSection(state, gam),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AppState state, GamificationData gam) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.burntOrange, AppColors.burntOrangeLight],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.burntOrange.withAlpha(50),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                state.profile.name.isNotEmpty
                    ? state.profile.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            state.profile.name.isNotEmpty ? state.profile.name : 'User',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.warmGold.withAlpha(15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.warmGold.withAlpha(40)),
            ),
            child: Text(
              'Level ${gam.currentLevel} — ${gam.levelTitle}',
              style: const TextStyle(
                color: AppColors.warmGold,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXPSection(GamificationData gam) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.warmBorder),
        ),
        child: XpBar(
          progress: gam.levelProgress,
          currentXP: gam.totalXP,
          targetXP: gam.xpForNextLevel,
          levelTitle: gam.levelTitle,
          level: gam.currentLevel,
        ),
      ),
    );
  }

  Widget _buildStreakSection(GamificationData gam) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.warmBorder),
        ),
        child: Row(
          children: [
            // Current streak
            Expanded(
              child: Column(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 28)),
                  const SizedBox(height: 6),
                  Text(
                    '${gam.currentStreak}',
                    style: const TextStyle(
                      color: AppColors.burntOrange,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Current\nStreak',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 60,
              color: AppColors.warmBorder,
            ),
            // Longest streak
            Expanded(
              child: Column(
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 28)),
                  const SizedBox(height: 6),
                  Text(
                    '${gam.longestStreak}',
                    style: const TextStyle(
                      color: AppColors.warmGold,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Longest\nStreak',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 60,
              color: AppColors.warmBorder,
            ),
            // Total sessions
            Expanded(
              child: Column(
                children: [
                  const Text('💪', style: TextStyle(fontSize: 28)),
                  const SizedBox(height: 6),
                  Text(
                    '${gam.completedSessionCount}',
                    style: const TextStyle(
                      color: AppColors.forestGreen,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Total\nSessions',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChallenge(AppState state) {
    final weeklyDone = state.weeklySessionCount;
    const weeklyTarget = 5;
    final progress = (weeklyDone / weeklyTarget).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.burntOrange.withAlpha(10),
              AppColors.warmGold.withAlpha(8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.burntOrange.withAlpha(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events,
                    color: AppColors.warmGold, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Weekly Challenge',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warmGold.withAlpha(15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '+50 XP',
                    style: TextStyle(
                      color: AppColors.warmGold,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Complete $weeklyTarget sessions this week',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.warmBorder,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.burntOrange,
                              AppColors.warmGold,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '$weeklyDone/$weeklyTarget',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesSection(GamificationData gam) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievements',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${gam.earnedBadges.length} of ${allBadges.length} unlocked',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.85,
            ),
            itemCount: allBadges.length,
            itemBuilder: (context, index) {
              final badge = allBadges[index];
              return BadgeCard(
                name: badge.name,
                description: badge.description,
                icon: badge.icon,
                isEarned: gam.earnedBadges.contains(badge.id),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(AppState state, GamificationData gam) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.warmBorder),
            ),
            child: Column(
              children: [
                _buildStatRow('Total XP Earned', '${gam.totalXP}'),
                Divider(color: AppColors.warmBorder, height: 20),
                _buildStatRow(
                    'Sessions Completed', '${gam.completedSessionCount}'),
                Divider(color: AppColors.warmBorder, height: 20),
                _buildStatRow(
                    'Current Level', '${gam.currentLevel} — ${gam.levelTitle}'),
                Divider(color: AppColors.warmBorder, height: 20),
                _buildStatRow('Pain Entries', '${state.painEntries.length}'),
                Divider(color: AppColors.warmBorder, height: 20),
                _buildStatRow(
                    'Badges Earned', '${gam.earnedBadges.length}/${allBadges.length}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

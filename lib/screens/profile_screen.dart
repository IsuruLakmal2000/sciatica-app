import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../models/gamification.dart';
import '../widgets/xp_bar.dart';
import '../widgets/badge_card.dart';
import 'settings_screen.dart';
import 'paywall_screen.dart';
import '../l10n/app_localizations.dart';

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
              _buildProfileHeader(context, state, gam),
              if (!state.profile.isPremium) _buildPremiumBanner(context),
              _buildXPSection(context, gam),
              _buildStreakSection(context, gam),
              _buildWeeklyChallenge(context, state),
              _buildBadgesSection(context, gam),
              _buildStatsSection(context, state, gam),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AppState state, GamificationData gam) {
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
            child: const Center(
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 44,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n('my_recovery'),
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
              '${context.l10n('level')} ${gam.currentLevel} — ${gam.getLevelTitle(context)}',
              style: TextStyle(
                color: AppColors.warmGold,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (state.profile.isPremium) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFD4A84A).withAlpha(20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD4A84A).withAlpha(50)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.workspace_premium_rounded, color: Color(0xFFD4A84A), size: 14),
                  SizedBox(width: 4),
                  Text(
                    'PREMIUM MEMBER',
                    style: TextStyle(
                      color: Color(0xFFD4A84A),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPremiumBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PaywallScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF2B1C40), // Premium dark purple
                Color(0xFF191026),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD4A84A).withAlpha(40), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF191026).withAlpha(50),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('👑', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 8),
                        Text(
                          'Sciatica Premium',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Unlock lifetime ad-free recovery, unlimited tracking, and custom bedtime routines.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4A84A),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4A84A).withAlpha(40),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Color(0xFF191026),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildXPSection(BuildContext context, GamificationData gam) {
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
          levelTitle: gam.getLevelTitle(context),
          level: gam.currentLevel,
        ),
      ),
    );
  }

  Widget _buildStreakSection(BuildContext context, GamificationData gam) {
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
                    context.l10n('current_streak'),
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
                    style: TextStyle(
                      color: AppColors.warmGold,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    context.l10n('longest_streak'),
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
                    context.l10n('total_sessions'),
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

  Widget _buildWeeklyChallenge(BuildContext context, AppState state) {
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
                Icon(Icons.emoji_events,
                    color: AppColors.warmGold, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.l10n('weekly_challenge'),
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
                  child: Text(
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
              context.l10n('weekly_challenge_desc', [weeklyTarget.toString()]),
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
                          gradient: LinearGradient(
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

  Widget _buildBadgesSection(BuildContext context, GamificationData gam) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n('achievements'),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n('badges_unlocked', [gam.earnedBadges.length.toString(), allBadges.length.toString()]),
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
                name: badge.getName(context),
                description: badge.getDescription(context),
                icon: badge.icon,
                isEarned: gam.earnedBadges.contains(badge.id),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, AppState state, GamificationData gam) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n('statistics'),
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
                _buildStatRow(context.l10n('total_xp_earned'), '${gam.totalXP}'),
                Divider(color: AppColors.warmBorder, height: 20),
                _buildStatRow(
                    context.l10n('sessions_completed'), '${gam.completedSessionCount}'),
                Divider(color: AppColors.warmBorder, height: 20),
                _buildStatRow(
                    context.l10n('current_level'), '${gam.currentLevel} — ${gam.getLevelTitle(context)}'),
                Divider(color: AppColors.warmBorder, height: 20),
                _buildStatRow(context.l10n('pain_entries_stat'), '${state.painEntries.length}'),
                Divider(color: AppColors.warmBorder, height: 20),
                _buildStatRow(
                    context.l10n('badges_earned_stat'), '${gam.earnedBadges.length}/${allBadges.length}'),
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

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import 'legal_document_screen.dart';
import 'paywall_screen.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);

    return Scaffold(
      backgroundColor: AppColors.espressoBrown,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildProfileCard(state),
              _buildSectionTitle(context.l10n('preferences')),
              _buildPreferencesSection(state),
              _buildSectionTitle(context.l10n('notifications')),
              _buildNotificationsSection(state),
              _buildSectionTitle(context.l10n('pain_profile')),
              _buildPainProfileSection(state),
              _buildSectionTitle(context.l10n('about')),
              _buildAboutSection(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.l10n('settings'),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warmBorder),
              ),
              child: Icon(Icons.close, color: AppColors.textSecondary, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(AppState state) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.burntOrange, AppColors.burntOrangeLight],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n('hi_there'),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${context.l10n('level')} ${state.gamification.currentLevel} — ${state.gamification.getLevelTitle(context)}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildPreferencesSection(AppState state) {
    final langMap = {
      'en': 'English',
      'es': 'Español',
      'fr': 'Français',
      'de': 'Deutsch',
      'it': 'Italiano',
    };
    final currentLang = langMap[state.languageCode] ?? 'English';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.dark_mode,
            iconColor: const Color(0xFFB4A0E8),
            title: context.l10n('dark_mode'),
            subtitle: context.l10n('dark_mode_sub'),
            value: state.profile.darkMode,
            onChanged: (val) => state.setDarkMode(val),
          ),
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.star_rounded,
            iconColor: AppColors.warmGold,
            title: 'Premium Member',
            subtitle: 'Disable all advertisements',
            value: state.profile.isPremium,
            onChanged: (val) => state.setPremiumStatus(val),
          ),
          _buildDivider(),
          _buildNavigationTile(
            icon: Icons.language,
            iconColor: AppColors.burntOrange,
            title: context.l10n('language'),
            subtitle: currentLang,
            onTap: () => _showLanguageSelector(context, state),
          ),
          _buildDivider(),
          _buildNavigationTile(
            icon: Icons.workspace_premium_rounded,
            iconColor: AppColors.warmGold,
            title: state.profile.isPremium ? 'Premium Active' : 'Upgrade to Premium',
            subtitle: state.profile.isPremium ? 'Lifetime membership active' : 'Unlock ads removal & bedtime stretches',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PaywallScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(AppState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.notifications_active,
            iconColor: AppColors.burntOrange,
            title: context.l10n('push_notifications'),
            subtitle: context.l10n('push_notifications_sub'),
            value: state.profile.notificationsEnabled,
            onChanged: (val) {
              state.profile.notificationsEnabled = val;
              state.saveProfile(state.profile);
            },
          ),
          _buildDivider(),
          _buildNavigationTile(
            icon: Icons.schedule,
            iconColor: AppColors.warmGold,
            title: context.l10n('reminder_time'),
            subtitle: state.profile.reminderTime,
            onTap: () => _pickTime(state),
          ),
        ],
      ),
    );
  }

  Widget _buildPainProfileSection(AppState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildInfoTile(
            icon: Icons.location_on,
            iconColor: AppColors.dangerRedLight,
            title: context.l10n('pain_location'),
            value: context.l10n('loc_${state.profile.painLocation}'),
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.speed,
            iconColor: AppColors.warmGold,
            title: context.l10n('severity'),
            value: context.l10n('sev_${state.profile.painSeverity}'),
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.accessibility_new,
            iconColor: AppColors.forestGreen,
            title: context.l10n('mobility_level'),
            value: context.l10n('mob_${state.profile.mobilityLevel}'),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildNavigationTile(
            icon: Icons.info_outline,
            iconColor: AppColors.burntOrange,
            title: context.l10n('app_version'),
            subtitle: '1.0.0',
            onTap: () {},
          ),
          _buildDivider(),
          _buildNavigationTile(
            icon: Icons.article_outlined,
            iconColor: AppColors.warmGold,
            title: context.l10n('terms_of_service'),
            subtitle: '',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const LegalDocumentScreen(
                    docType: LegalDocType.termsOfUse,
                  ),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildNavigationTile(
            icon: Icons.privacy_tip_outlined,
            iconColor: const Color(0xFFB4A0E8),
            title: context.l10n('privacy_policy'),
            subtitle: '',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const LegalDocumentScreen(
                    docType: LegalDocType.privacyPolicy,
                  ),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildNavigationTile(
            icon: Icons.health_and_safety_outlined,
            iconColor: AppColors.dangerRedLight,
            title: context.l10n('medical_disclaimer'),
            subtitle: '',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const LegalDocumentScreen(
                    docType: LegalDocType.medicalDisclaimer,
                  ),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildNavigationTile(
            icon: Icons.help_outline,
            iconColor: AppColors.forestGreen,
            title: context.l10n('help_support'),
            subtitle: '',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.darkSurface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.warmBorder),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.burntOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 68,
      endIndent: 16,
      color: AppColors.warmBorder,
    );
  }

  String _formatOption(String value) {
    if (value.isEmpty) return 'Not set';
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .map(
            (w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }

  Future<void> _pickTime(AppState state) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null && mounted) {
      state.profile.reminderTime = time.format(context);
      state.saveProfile(state.profile);
    }
  }

  void _showLanguageSelector(BuildContext context, AppState state) {
    final Map<String, String> languages = {
      'en': 'English',
      'es': 'Español',
      'fr': 'Français',
      'de': 'Deutsch',
      'it': 'Italiano',
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
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
            const SizedBox(height: 16),
            Text(
              context.l10n('language'),
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            ...languages.entries.map((entry) {
              final isSelected = state.languageCode == entry.key;
              return ListTile(
                onTap: () {
                  state.setLanguage(entry.key);
                  Navigator.of(ctx).pop();
                },
                leading: Icon(
                  Icons.check_circle_rounded,
                  color: isSelected ? AppColors.burntOrange : Colors.transparent,
                  size: 20,
                ),
                title: Text(
                  entry.value,
                  style: TextStyle(
                    color: isSelected ? AppColors.burntOrange : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
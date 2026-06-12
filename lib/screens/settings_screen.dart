import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';

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
              _buildSectionTitle('PREFERENCES'),
              _buildPreferencesSection(state),
              _buildSectionTitle('NOTIFICATIONS'),
              _buildNotificationsSection(state),
              _buildSectionTitle('PAIN PROFILE'),
              _buildPainProfileSection(state),
              _buildSectionTitle('ABOUT'),
              _buildAboutSection(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        'Settings',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 26,
          fontWeight: FontWeight.w800,
        ),
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
            child: Center(
              child: Text(
                state.profile.name.isNotEmpty
                    ? state.profile.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.profile.name.isNotEmpty
                      ? state.profile.name
                      : 'User',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Level ${state.gamification.currentLevel} — ${state.gamification.levelTitle}',
                  style: const TextStyle(
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
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildPreferencesSection(AppState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.dark_mode,
            iconColor: const Color(0xFFB4A0E8),
            title: 'Dark Mode',
            subtitle: 'Use dark theme (recommended)',
            value: state.profile.darkMode,
            onChanged: (val) => state.setDarkMode(val),
          ),
          _buildDivider(),
          _buildNavigationTile(
            icon: Icons.language,
            iconColor: AppColors.burntOrange,
            title: 'Language',
            subtitle: 'English',
            onTap: () {},
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
            title: 'Push Notifications',
            subtitle: 'Receive daily reminders',
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
            title: 'Reminder Time',
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
            title: 'Pain Location',
            value: _formatOption(state.profile.painLocation),
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.speed,
            iconColor: AppColors.warmGold,
            title: 'Severity',
            value: _formatOption(state.profile.painSeverity),
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.accessibility_new,
            iconColor: AppColors.forestGreen,
            title: 'Mobility Level',
            value: _formatOption(state.profile.mobilityLevel),
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
            title: 'App Version',
            subtitle: '1.0.0',
            onTap: () {},
          ),
          _buildDivider(),
          _buildNavigationTile(
            icon: Icons.article_outlined,
            iconColor: AppColors.warmGold,
            title: 'Terms of Service',
            subtitle: '',
            onTap: () {},
          ),
          _buildDivider(),
          _buildNavigationTile(
            icon: Icons.privacy_tip_outlined,
            iconColor: const Color(0xFFB4A0E8),
            title: 'Privacy Policy',
            subtitle: '',
            onTap: () {},
          ),
          _buildDivider(),
          _buildNavigationTile(
            icon: Icons.help_outline,
            iconColor: AppColors.forestGreen,
            title: 'Help & Support',
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: const TextStyle(
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
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
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
              style: const TextStyle(
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
    return const Divider(
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.burntOrange,
              surface: AppColors.darkSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null && mounted) {
      state.profile.reminderTime = time.format(context);
      state.saveProfile(state.profile);
    }
  }
}
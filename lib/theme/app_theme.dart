import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static bool isDark = true;

  // ── Dark Mode Base ──
  static Color get espressoBrown => isDark ? const Color(0xFF1C1410) : const Color(0xFFF5ECD7);
  static Color get darkSurface => isDark ? const Color(0xFF251A12) : const Color(0xFFFFFFFF);
  static Color get warmBorder => isDark ? const Color(0xFF3A2A1E) : const Color(0xFFE8DCC4);
  static Color get darkElevated => isDark ? const Color(0xFF2E1F15) : const Color(0xFFE8DCC4);

  // ── Primary Accent ──
  static const Color burntOrange = Color(0xFFE8632A);
  static const Color burntOrangeLight = Color(0xFFFF8A50);
  static const Color burntOrangeDark = Color(0xFFC44D1A);

  // ── Secondary Accent ──
  static const Color _warmGoldLight = Color(0xFFFFD580);
  static const Color warmGoldDark = Color(0xFFD4A84A);
  static Color get warmGold => isDark ? _warmGoldLight : warmGoldDark;

  // ── Success / Recovery ──
  static const Color forestGreen = Color(0xFF4A9E5C);
  static const Color forestGreenLight = Color(0xFF6BBF7B);

  // ── Light Mode ──
  static const Color sandyCream = Color(0xFFF5ECD7);
  static const Color sandyCreamDark = Color(0xFFE8DCC4);

  // ── Text ──
  static Color get textPrimary => isDark ? const Color(0xFFF5ECD7) : const Color(0xFF2D1A0E);
  static Color get textSecondary => isDark ? const Color(0xFFA89080) : const Color(0xFF6B5A4E);
  static Color get textMuted => isDark ? const Color(0xFF7A6A5A) : const Color(0xFF9A8A7A);
  static const Color textOnOrange = Color(0xFFFFFFFF);

  // ── Danger ──
  static const Color dangerRed = Color(0xFFE84040);
  static const Color dangerRedLight = Color(0xFFFF6B6B);

  // ── Pain score gradient colors ──
  static const Color painLow = Color(0xFF4A9E5C);
  static const Color painMedLow = Color(0xFF7BC25A);
  static const Color painMedium = Color(0xFFD4C44A);
  static const Color painMedHigh = Color(0xFFE8A032);
  static const Color painHigh = Color(0xFFE8632A);
  static const Color painExtreme = Color(0xFFE84040);

  static Color painScoreColor(int score) {
    if (score <= 2) return painLow;
    if (score <= 4) return painMedLow;
    if (score <= 5) return painMedium;
    if (score <= 7) return painMedHigh;
    if (score <= 8) return painHigh;
    return painExtreme;
  }
}

class AppTheme {
  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: GoogleFonts.nunito(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: primary,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.nunito(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      headlineLarge: GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      headlineMedium: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      headlineSmall: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleLarge: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      titleMedium: GoogleFonts.nunito(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleSmall: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: primary,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondary,
        height: 1.4,
      ),
      bodySmall: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      labelLarge: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: 0.3,
      ),
      labelMedium: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: secondary,
      ),
      labelSmall: GoogleFonts.nunito(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondary,
        letterSpacing: 0.3,
      ),
    );
  }

  static ThemeData get darkTheme {
    final textTheme = _buildTextTheme(
      AppColors.textPrimary,
      AppColors.textSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.espressoBrown,
      colorScheme: ColorScheme.dark(
        primary: AppColors.burntOrange,
        onPrimary: Colors.white,
        secondary: AppColors.warmGold,
        onSecondary: AppColors.espressoBrown,
        surface: AppColors.darkSurface,
        onSurface: AppColors.textPrimary,
        error: AppColors.dangerRed,
        onError: Colors.white,
        outline: AppColors.warmBorder,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.espressoBrown,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.warmBorder, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.burntOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.burntOrange,
          side: const BorderSide(color: AppColors.burntOrange, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.burntOrange,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.burntOrange;
          }
          return AppColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.burntOrange.withAlpha(80);
          }
          return AppColors.warmBorder;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.burntOrange,
        inactiveTrackColor: AppColors.warmBorder,
        thumbColor: AppColors.burntOrange,
        overlayColor: Color(0x29E8632A),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.warmBorder,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedColor: AppColors.burntOrange,
        disabledColor: AppColors.darkSurface,
        labelStyle: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
        secondaryLabelStyle: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.warmBorder),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      iconTheme: IconThemeData(
        color: AppColors.textSecondary,
        size: 24,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.warmBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.warmBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.burntOrange, width: 2),
        ),
        hintStyle: GoogleFonts.nunito(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.nunito(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.darkSurface,
        dialBackgroundColor: AppColors.espressoBrown,
        dialHandColor: AppColors.burntOrange,
        dialTextColor: AppColors.textPrimary,
        entryModeIconColor: AppColors.burntOrange,
        hourMinuteColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.burntOrange.withAlpha(50)
                : AppColors.espressoBrown),
        hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? Colors.white
                : AppColors.textPrimary),
        dayPeriodColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.burntOrange
                : AppColors.espressoBrown),
        dayPeriodTextColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? Colors.white
                : AppColors.textPrimary),
      ),
    );
  }

  static ThemeData get lightTheme {
    final textTheme = _buildTextTheme(
      const Color(0xFF2D1A0E),
      const Color(0xFF6B5A4E),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.sandyCream,
      colorScheme: const ColorScheme.light(
        primary: AppColors.burntOrange,
        onPrimary: Colors.white,
        secondary: AppColors.warmGoldDark,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: Color(0xFF2D1A0E),
        error: AppColors.dangerRed,
        onError: Colors.white,
        outline: AppColors.sandyCreamDark,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.sandyCream,
        foregroundColor: const Color(0xFF2D1A0E),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF2D1A0E),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.sandyCreamDark, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.burntOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.burntOrange,
        unselectedItemColor: const Color(0xFF9A8A7A),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.burntOrange;
          }
          return const Color(0xFF9A8A7A);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.burntOrange.withAlpha(80);
          }
          return AppColors.sandyCreamDark;
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.sandyCreamDark,
        thickness: 1,
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: Colors.white,
        dialBackgroundColor: AppColors.sandyCream,
        dialHandColor: AppColors.burntOrange,
        dialTextColor: const Color(0xFF2D1A0E),
        entryModeIconColor: AppColors.burntOrange,
        hourMinuteColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.burntOrange.withAlpha(50)
                : AppColors.sandyCreamDark),
        hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.burntOrange
                : const Color(0xFF2D1A0E)),
        dayPeriodColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.burntOrange
                : AppColors.sandyCreamDark),
        dayPeriodTextColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? Colors.white
                : const Color(0xFF2D1A0E)),
      ),
    );
  }
}

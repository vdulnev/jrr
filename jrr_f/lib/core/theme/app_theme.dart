import 'package:flutter/material.dart';

/// Design tokens matching the JSX prototype.
abstract final class AppColors {
  static const bg0 = Color(0xFF080809);
  static const bg1 = Color(0xFF0E0E10);
  static const bg2 = Color(0xFF161618);
  static const bg3 = Color(0xFF1E1E21);
  static const bg4 = Color(0xFF26262A);

  static const line = Color(0x0FFFFFFF); // ~6%
  static const line2 = Color(0x1AFFFFFF); // ~10%

  static const text = Color(0xFFF0EDE8);
  static const text2 = Color(0x8CF0EDE8); // ~55%
  static const text3 = Color(0x4DF0EDE8); // ~30%

  static const accent = Color(0xFFC8922A);
  static const accentDim = Color(0x22C8922A); // ~13%
}

abstract final class AppFonts {
  static const sans = 'Inter';
  static const mono = 'IBMPlexMono';
}

abstract final class AppTextStyles {
  /// LIBRARY, OUTPUT, PLAYBACK — mono section labels (11px)
  static const sectionLabel = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 11,
    letterSpacing: 2.5,
    color: AppColors.accent,
  );

  /// Main screen titles (24px - MD3 Headline Small)
  static const screenTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -0.5,
  );

  /// Sub-screen titles (20px - HIG Title 3)
  static const subScreenTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -0.4,
    height: 1.2,
  );

  /// List item primary text (16px - MD3 Body Large)
  static const itemTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
    letterSpacing: -0.2,
  );

  /// Secondary/subtitle text (13px - HIG Footnote)
  static const itemSubtitle = TextStyle(
    fontSize: 13,
    color: AppColors.text2,
    height: 1.3,
  );

  /// Mono label — dates, counts, durations (12px - MD3 Label Medium)
  static const monoLabel = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 12,
    color: AppColors.text3,
  );

  /// Now-playing track name (22px)
  static const nowPlayingTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -0.4,
    height: 1.2,
  );

  /// Now-playing artist (16px)
  static const nowPlayingArtist = TextStyle(
    fontSize: 16,
    color: AppColors.text2,
  );

  /// Standard label for buttons, tabs, inputs (14px - MD3 Label Large)
  static const labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  /// Legacy aliases for action styles
  static const accentButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.accent,
  );

  /// Small accent labels (12px)
  static const accentSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.accent,
  );

  /// Avatar initial letter
  static const avatarLetter = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
  );

  /// Section heading — UP NEXT
  static const sectionHeading = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.text3,
    letterSpacing: 0.5,
  );

  /// Empty / muted state text
  static const emptyState = TextStyle(fontSize: 14, color: AppColors.text3);

  /// Chip label (12px)
  static const chipLabel = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 12,
    color: AppColors.text2,
  );
}

ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    fontFamily: AppFonts.sans,
    scaffoldBackgroundColor: AppColors.bg1,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.bg1,
      primary: AppColors.accent,
      onPrimary: Colors.black,
      secondary: AppColors.accent,
      onSecondary: Colors.black,
      onSurface: AppColors.text,
      onSurfaceVariant: AppColors.text2,
      outline: AppColors.line2,
      surfaceContainerHighest: AppColors.bg3,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: AppTextStyles.subScreenTitle,
      iconTheme: IconThemeData(color: AppColors.text2),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.line,
      thickness: 1,
      space: 0,
    ),
    listTileTheme: const ListTileThemeData(
      textColor: AppColors.text,
      iconColor: AppColors.text2,
      titleTextStyle: AppTextStyles.itemTitle,
      subtitleTextStyle: AppTextStyles.itemSubtitle,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bg2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.line2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.line2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.accent),
      ),
      hintStyle: AppTextStyles.emptyState,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.bg3,
      contentTextStyle: AppTextStyles.itemTitle,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      behavior: SnackBarBehavior.floating,
    ),
    textTheme: const TextTheme(
      headlineLarge: AppTextStyles.screenTitle,
      titleLarge: AppTextStyles.subScreenTitle,
      titleMedium: AppTextStyles.itemTitle,
      titleSmall: AppTextStyles.sectionHeading,
      bodyLarge: AppTextStyles.itemTitle,
      bodyMedium: AppTextStyles.labelLarge,
      bodySmall: AppTextStyles.itemSubtitle,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.monoLabel,
      labelSmall: AppTextStyles.sectionLabel,
    ),
  );
}

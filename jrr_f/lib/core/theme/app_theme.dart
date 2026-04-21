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
      titleTextStyle: TextStyle(
        fontFamily: AppFonts.sans,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
        letterSpacing: -0.4,
      ),
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
      hintStyle: const TextStyle(color: AppColors.text3, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.bg3,
      contentTextStyle: const TextStyle(
        fontFamily: AppFonts.sans,
        color: AppColors.text,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      behavior: SnackBarBehavior.floating,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
        letterSpacing: -0.5,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
        letterSpacing: -0.4,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.text3,
        letterSpacing: 1,
      ),
      bodyLarge: TextStyle(fontSize: 14, color: AppColors.text),
      bodyMedium: TextStyle(fontSize: 13, color: AppColors.text),
      bodySmall: TextStyle(fontSize: 11, color: AppColors.text3),
      labelSmall: TextStyle(
        fontFamily: AppFonts.mono,
        fontSize: 10,
        color: AppColors.text3,
      ),
      labelMedium: TextStyle(
        fontFamily: AppFonts.mono,
        fontSize: 11,
        color: AppColors.text3,
      ),
    ),
  );
}

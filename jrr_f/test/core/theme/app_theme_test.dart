import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/theme/app_theme.dart';

void main() {
  group('AppColors tokens', () {
    test('background tiers are distinct and ordered', () {
      const ladder = [
        AppColors.bg0,
        AppColors.bg1,
        AppColors.bg2,
        AppColors.bg3,
        AppColors.bg4,
      ];
      expect(ladder.toSet().length, ladder.length);
    });

    test('text tokens have descending alpha for hierarchy', () {
      expect(AppColors.text.a, greaterThan(AppColors.text2.a));
      expect(AppColors.text2.a, greaterThan(AppColors.text3.a));
    });

    test('accentDim is a faded variant of accent', () {
      expect(
        (AppColors.accentDim.r * 255).round(),
        (AppColors.accent.r * 255).round(),
      );
      expect(
        (AppColors.accentDim.g * 255).round(),
        (AppColors.accent.g * 255).round(),
      );
      expect(
        (AppColors.accentDim.b * 255).round(),
        (AppColors.accent.b * 255).round(),
      );
      expect(AppColors.accentDim.a, lessThan(AppColors.accent.a));
    });

    test('line tokens are translucent overlays', () {
      expect(AppColors.line.a, lessThan(1.0));
      expect(AppColors.line2.a, lessThan(1.0));
    });
  });

  group('AppFonts', () {
    test('exposes Inter and IBMPlexMono families', () {
      expect(AppFonts.sans, 'Inter');
      expect(AppFonts.mono, 'IBMPlexMono');
    });
  });

  group('AppTextStyles', () {
    test('sectionLabel is mono and accented', () {
      expect(AppTextStyles.sectionLabel.fontFamily, AppFonts.mono);
      expect(AppTextStyles.sectionLabel.color, AppColors.accent);
    });

    test('itemTitle uses text color and medium weight', () {
      expect(AppTextStyles.itemTitle.color, AppColors.text);
      expect(AppTextStyles.itemTitle.fontWeight, FontWeight.w500);
    });

    test('emptyState is muted with text3', () {
      expect(AppTextStyles.emptyState.color, AppColors.text3);
    });
  });

  group('buildAppTheme', () {
    final theme = buildAppTheme();

    test('returns a dark theme', () {
      expect(theme.brightness, Brightness.dark);
    });

    test('uses the sans font family', () {
      expect(theme.textTheme.bodyLarge?.fontFamily, AppFonts.sans);
    });

    test('scaffoldBackground is bg1', () {
      expect(theme.scaffoldBackgroundColor, AppColors.bg1);
    });

    test('colorScheme exposes accent and surface tokens', () {
      expect(theme.colorScheme.primary, AppColors.accent);
      expect(theme.colorScheme.secondary, AppColors.accent);
      expect(theme.colorScheme.surface, AppColors.bg1);
      expect(theme.colorScheme.onSurface, AppColors.text);
      expect(theme.colorScheme.outline, AppColors.line2);
      expect(theme.colorScheme.surfaceContainerHighest, AppColors.bg3);
    });

    test('appBarTheme is flat and transparent', () {
      expect(theme.appBarTheme.elevation, 0);
      expect(theme.appBarTheme.scrolledUnderElevation, 0);
      expect(theme.appBarTheme.backgroundColor, Colors.transparent);
      expect(theme.appBarTheme.iconTheme?.color, AppColors.text2);
    });

    test('dividerTheme uses the line token', () {
      expect(theme.dividerTheme.color, AppColors.line);
      expect(theme.dividerTheme.thickness, 1);
      expect(theme.dividerTheme.space, 0);
    });

    test('listTileTheme inherits text and icon palette', () {
      expect(theme.listTileTheme.textColor, AppColors.text);
      expect(theme.listTileTheme.iconColor, AppColors.text2);
      expect(theme.listTileTheme.titleTextStyle, AppTextStyles.itemTitle);
      expect(theme.listTileTheme.subtitleTextStyle, AppTextStyles.itemSubtitle);
    });

    test('inputDecorationTheme is filled with bg2', () {
      expect(theme.inputDecorationTheme.filled, isTrue);
      expect(theme.inputDecorationTheme.fillColor, AppColors.bg2);
    });

    test('snackBarTheme uses floating behaviour', () {
      expect(theme.snackBarTheme.behavior, SnackBarBehavior.floating);
      expect(theme.snackBarTheme.backgroundColor, AppColors.bg3);
    });

    test('textTheme maps headline/title/body/label styles', () {
      void expectMatches(TextStyle? applied, TextStyle source) {
        expect(applied, isNotNull);
        expect(applied!.fontSize, source.fontSize);
        expect(applied.fontWeight, source.fontWeight);
        if (source.color != null) {
          expect(applied.color, source.color);
        }
        expect(applied.letterSpacing, source.letterSpacing);
      }

      expectMatches(theme.textTheme.headlineLarge, AppTextStyles.screenTitle);
      expectMatches(theme.textTheme.titleLarge, AppTextStyles.subScreenTitle);
      expectMatches(theme.textTheme.titleMedium, AppTextStyles.itemTitle);
      expectMatches(theme.textTheme.titleSmall, AppTextStyles.sectionHeading);
      expectMatches(theme.textTheme.bodyLarge, AppTextStyles.itemTitle);
      expectMatches(theme.textTheme.bodyMedium, AppTextStyles.labelLarge);
      expectMatches(theme.textTheme.bodySmall, AppTextStyles.itemSubtitle);
      expectMatches(theme.textTheme.labelLarge, AppTextStyles.labelLarge);
      expectMatches(theme.textTheme.labelMedium, AppTextStyles.monoLabel);
      expectMatches(theme.textTheme.labelSmall, AppTextStyles.sectionLabel);
    });

    test('returns a fresh ThemeData instance per call', () {
      expect(identical(buildAppTheme(), buildAppTheme()), isFalse);
    });
  });
}

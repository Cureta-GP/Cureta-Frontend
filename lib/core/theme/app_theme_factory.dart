import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_durations.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';
import 'breakpoints.dart';

class AppThemeFactory {
  const AppThemeFactory._();

  static ThemeData create({
    required Brightness brightness,
    required DeviceType device,
    required double screenWidth,
    required double screenHeight,
  }) {
    final appColors = AppColors.fromBrightness(brightness);
    final spacing = _fluidSpacingFor(screenWidth);
    final radius = _fluidRadiusFor(screenWidth);
    final typographyReferenceWidth = screenWidth < screenHeight
        ? screenWidth
        : screenHeight;
    final typography = _fluidTypographyFor(
      device: device,
      screenWidth: typographyReferenceWidth,
    );
    const durations = AppDurations.standard;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: appColors.primary,
      onPrimary: Colors.white,
      secondary: appColors.secondary,
      onSecondary: appColors.textPrimary,
      error: appColors.error,
      onError: Colors.white,
      surface: appColors.surface,
      onSurface: appColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: appColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: appColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.md),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.lg,
            vertical: spacing.md,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: appColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.full),
        ),
      ),
      extensions: [appColors, typography, spacing, radius, durations],
    );
  }

  static AppTypography _typographyFor(DeviceType device) {
    return switch (device) {
      DeviceType.mobile => AppTypography.mobile,
      DeviceType.tablet => AppTypography.tablet,
      DeviceType.largeTablet => AppTypography.tablet,
      DeviceType.desktop => AppTypography.desktop,
    };
  }

  static AppTypography _fluidTypographyFor({
    required DeviceType device,
    required double screenWidth,
  }) {
    if (screenWidth < Breakpoints.tablet) {
      final t = _normalize(screenWidth, Breakpoints.mobile, Breakpoints.tablet);
      return AppTypography.mobile.lerp(AppTypography.tablet, t);
    }
    if (screenWidth < Breakpoints.desktop) {
      final t = _normalize(
        screenWidth,
        Breakpoints.tablet,
        Breakpoints.desktop,
      );
      return AppTypography.tablet.lerp(AppTypography.desktop, t);
    }
    return _typographyFor(device);
  }

  static AppSpacing _fluidSpacingFor(double screenWidth) {
    if (screenWidth < Breakpoints.tablet) {
      final t = _normalize(screenWidth, Breakpoints.mobile, Breakpoints.tablet);
      return AppSpacing.mobile.lerp(AppSpacing.tablet, t);
    }
    if (screenWidth < Breakpoints.desktop) {
      final t = _normalize(
        screenWidth,
        Breakpoints.tablet,
        Breakpoints.desktop,
      );
      return AppSpacing.tablet.lerp(AppSpacing.desktop, t);
    }
    return AppSpacing.desktop;
  }

  static AppRadius _fluidRadiusFor(double screenWidth) {
    if (screenWidth < Breakpoints.tablet) {
      final t = _normalize(screenWidth, Breakpoints.mobile, Breakpoints.tablet);
      return AppRadius.mobile.lerp(AppRadius.tablet, t);
    }
    if (screenWidth < Breakpoints.desktop) {
      final t = _normalize(
        screenWidth,
        Breakpoints.tablet,
        Breakpoints.desktop,
      );
      return AppRadius.tablet.lerp(AppRadius.desktop, t);
    }
    return AppRadius.desktop;
  }

  static double _normalize(double value, double min, double max) {
    if (max <= min) return 0;
    final normalized = (value - min) / (max - min);
    return normalized.clamp(0.0, 1.0);
  }
}

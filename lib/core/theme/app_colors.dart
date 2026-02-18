import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.primaryDark,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.error,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.divider,
    required this.icon,
  });

  final Color primary;
  final Color primaryDark;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color error;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color divider;
  final Color icon;

  static const light = AppColors(
    primary: Color(0xFF00A1A9),
    primaryDark: Color(0xFF133A3E),
    secondary: Color(0xFFEDF7F8),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFAFAFA),
    error: Color(0xFFB00020),
    textPrimary: Color(0xFF212121),
    textSecondary: Color(0xFF757575),
    textHint: Color(0xFFBDBDBD),
    divider: Color(0xFFE0E0E0),
    icon: Color(0xFF99A1AF),
  );

  static const dark = AppColors(
    primary: Color(0xFF00A1A9),
    primaryDark: Color(0xFF133A3E),
    secondary: Color(0xFF1D2B2D),
    background: Color(0xFF133A3E),
    surface: Color(0xFF1C2328),
    error: Color(0xFFCF6679),
    textPrimary: Color(0xFFF5F5F5),
    textSecondary: Color(0xFFB0BEC5),
    textHint: Color(0xFF90A4AE),
    divider: Color(0xFF37474F),
    icon: Color(0xFFB0BEC5),
  );

  static AppColors fromBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryDark,
    Color? secondary,
    Color? background,
    Color? surface,
    Color? error,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? divider,
    Color? icon,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      error: error ?? this.error,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      divider: divider ?? this.divider,
      icon: icon ?? this.icon,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      error: Color.lerp(error, other.error, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
    );
  }
}

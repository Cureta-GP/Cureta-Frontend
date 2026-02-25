import 'package:flutter/material.dart';

@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({
    required this.hairline,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  final double hairline;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  static const mobile = AppSpacing(
    hairline: 1,
    xs: 8,
    sm: 10,
    md: 12,
    lg: 16,
    xl: 24,
    xxl: 32,
  );

  static const tablet = AppSpacing(
    hairline: 1.2,
    xs: 10,
    sm: 12,
    md: 16,
    lg: 20,
    xl: 28,
    xxl: 40,
  );

  static const desktop = AppSpacing(
    hairline: 1.4,
    xs: 12,
    sm: 14,
    md: 18,
    lg: 24,
    xl: 32,
    xxl: 48,
  );

  @override
  AppSpacing copyWith({
    double? hairline,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return AppSpacing(
      hairline: hairline ?? this.hairline,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  AppSpacing lerp(ThemeExtension<AppSpacing>? other, double t) {
    if (other is! AppSpacing) return this;
    return AppSpacing(
      hairline: hairline + (other.hairline - hairline) * t,
      xs: xs + (other.xs - xs) * t,
      sm: sm + (other.sm - sm) * t,
      md: md + (other.md - md) * t,
      lg: lg + (other.lg - lg) * t,
      xl: xl + (other.xl - xl) * t,
      xxl: xxl + (other.xxl - xxl) * t,
    );
  }
}

import 'package:flutter/material.dart';

@immutable
class AppRadius extends ThemeExtension<AppRadius> {
  const AppRadius({
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.full,
  });

  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double full;

  static const mobile = AppRadius(sm: 10, md: 14, lg: 18, xl: 24, full: 9999);
  static const tablet = AppRadius(sm: 12, md: 16, lg: 20, xl: 28, full: 9999);
  static const desktop = AppRadius(sm: 14, md: 18, lg: 24, xl: 32, full: 9999);

  @override
  AppRadius copyWith({
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? full,
  }) {
    return AppRadius(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      full: full ?? this.full,
    );
  }

  @override
  AppRadius lerp(ThemeExtension<AppRadius>? other, double t) {
    if (other is! AppRadius) return this;
    return AppRadius(
      sm: sm + (other.sm - sm) * t,
      md: md + (other.md - md) * t,
      lg: lg + (other.lg - lg) * t,
      xl: xl + (other.xl - xl) * t,
      full: full,
    );
  }
}

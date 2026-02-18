import 'package:flutter/material.dart';

@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.hero,
    required this.title,
    required this.body,
    required this.label,
    required this.button,
  });

  final TextStyle hero;
  final TextStyle title;
  final TextStyle body;
  final TextStyle label;
  final TextStyle button;

  static const mobile = AppTypography(
    hero: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    title: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    body: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    label: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    button: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );

  static const tablet = AppTypography(
    hero: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
    title: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    body: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
    label: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    button: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  );

  static const desktop = AppTypography(
    hero: TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
    title: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    body: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
    label: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
    button: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
  );

  @override
  AppTypography copyWith({
    TextStyle? hero,
    TextStyle? title,
    TextStyle? body,
    TextStyle? label,
    TextStyle? button,
  }) {
    return AppTypography(
      hero: hero ?? this.hero,
      title: title ?? this.title,
      body: body ?? this.body,
      label: label ?? this.label,
      button: button ?? this.button,
    );
  }

  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;
    return AppTypography(
      hero: TextStyle.lerp(hero, other.hero, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
    );
  }
}

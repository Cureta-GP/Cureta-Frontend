import 'package:flutter/material.dart';

@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.hero,
    required this.title,
    required this.body,
    required this.label,
    required this.button,
    required this.medicalRecordQuestion,
    required this.medicalRecordInput,
    required this.medicalRecordButton,
    required this.medicalRecordStep,
    required this.medicalRecordProgress,
    required this.medicalRecordHelper,
    required this.medicalRecordCancel,
  });

  final TextStyle hero;
  final TextStyle title;
  final TextStyle body;
  final TextStyle label;
  final TextStyle button;
  final TextStyle medicalRecordQuestion;
  final TextStyle medicalRecordInput;
  final TextStyle medicalRecordButton;
  final TextStyle medicalRecordStep;
  final TextStyle medicalRecordProgress;
  final TextStyle medicalRecordHelper;
  final TextStyle medicalRecordCancel;

  static const mobile = AppTypography(
    hero: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    title: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    body: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    label: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    button: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    medicalRecordQuestion: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
    medicalRecordInput: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
    medicalRecordButton: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    medicalRecordStep: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    medicalRecordProgress: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    medicalRecordHelper: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    medicalRecordCancel: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  );

  static const tablet = AppTypography(
    hero: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
    title: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    body: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
    label: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    button: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    medicalRecordQuestion: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
    medicalRecordInput: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
    medicalRecordButton: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    medicalRecordStep: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    medicalRecordProgress: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    medicalRecordHelper: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    medicalRecordCancel: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  );

  static const desktop = AppTypography(
    hero: TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
    title: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    body: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
    label: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
    button: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    medicalRecordQuestion: TextStyle(fontSize: 38, fontWeight: FontWeight.w700),
    medicalRecordInput: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
    medicalRecordButton: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
    medicalRecordStep: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    medicalRecordProgress: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    medicalRecordHelper: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
    medicalRecordCancel: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
  );

  @override
  AppTypography copyWith({
    TextStyle? hero,
    TextStyle? title,
    TextStyle? body,
    TextStyle? label,
    TextStyle? button,
    TextStyle? medicalRecordQuestion,
    TextStyle? medicalRecordInput,
    TextStyle? medicalRecordButton,
    TextStyle? medicalRecordStep,
    TextStyle? medicalRecordProgress,
    TextStyle? medicalRecordHelper,
    TextStyle? medicalRecordCancel,
  }) {
    return AppTypography(
      hero: hero ?? this.hero,
      title: title ?? this.title,
      body: body ?? this.body,
      label: label ?? this.label,
      button: button ?? this.button,
      medicalRecordQuestion:
          medicalRecordQuestion ?? this.medicalRecordQuestion,
      medicalRecordInput: medicalRecordInput ?? this.medicalRecordInput,
      medicalRecordButton: medicalRecordButton ?? this.medicalRecordButton,
      medicalRecordStep: medicalRecordStep ?? this.medicalRecordStep,
      medicalRecordProgress:
          medicalRecordProgress ?? this.medicalRecordProgress,
      medicalRecordHelper: medicalRecordHelper ?? this.medicalRecordHelper,
      medicalRecordCancel: medicalRecordCancel ?? this.medicalRecordCancel,
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
      medicalRecordQuestion: TextStyle.lerp(
        medicalRecordQuestion,
        other.medicalRecordQuestion,
        t,
      )!,
      medicalRecordInput: TextStyle.lerp(
        medicalRecordInput,
        other.medicalRecordInput,
        t,
      )!,
      medicalRecordButton: TextStyle.lerp(
        medicalRecordButton,
        other.medicalRecordButton,
        t,
      )!,
      medicalRecordStep: TextStyle.lerp(
        medicalRecordStep,
        other.medicalRecordStep,
        t,
      )!,
      medicalRecordProgress: TextStyle.lerp(
        medicalRecordProgress,
        other.medicalRecordProgress,
        t,
      )!,
      medicalRecordHelper: TextStyle.lerp(
        medicalRecordHelper,
        other.medicalRecordHelper,
        t,
      )!,
      medicalRecordCancel: TextStyle.lerp(
        medicalRecordCancel,
        other.medicalRecordCancel,
        t,
      )!,
    );
  }
}

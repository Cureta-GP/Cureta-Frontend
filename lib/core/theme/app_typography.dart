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
    required this.medicalRecordScreenTitle,
    required this.medicalRecordCardTitle,
    required this.medicalRecordPickerLabel,
    required this.medicalRecordChoice,
    required this.medicalRecordSkip,
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
  final TextStyle medicalRecordScreenTitle;
  final TextStyle medicalRecordCardTitle;
  final TextStyle medicalRecordPickerLabel;
  final TextStyle medicalRecordChoice;
  final TextStyle medicalRecordSkip;

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
    medicalRecordScreenTitle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordCardTitle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordPickerLabel: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    medicalRecordChoice: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    medicalRecordSkip: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
    medicalRecordScreenTitle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordCardTitle: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordPickerLabel: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    medicalRecordChoice: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    medicalRecordSkip: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
    medicalRecordScreenTitle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordCardTitle: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordPickerLabel: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
    medicalRecordChoice: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    medicalRecordSkip: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
    TextStyle? medicalRecordScreenTitle,
    TextStyle? medicalRecordCardTitle,
    TextStyle? medicalRecordPickerLabel,
    TextStyle? medicalRecordChoice,
    TextStyle? medicalRecordSkip,
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
      medicalRecordScreenTitle:
          medicalRecordScreenTitle ?? this.medicalRecordScreenTitle,
      medicalRecordCardTitle:
          medicalRecordCardTitle ?? this.medicalRecordCardTitle,
      medicalRecordPickerLabel:
          medicalRecordPickerLabel ?? this.medicalRecordPickerLabel,
      medicalRecordChoice: medicalRecordChoice ?? this.medicalRecordChoice,
      medicalRecordSkip: medicalRecordSkip ?? this.medicalRecordSkip,
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
      medicalRecordScreenTitle: TextStyle.lerp(
        medicalRecordScreenTitle,
        other.medicalRecordScreenTitle,
        t,
      )!,
      medicalRecordCardTitle: TextStyle.lerp(
        medicalRecordCardTitle,
        other.medicalRecordCardTitle,
        t,
      )!,
      medicalRecordPickerLabel: TextStyle.lerp(
        medicalRecordPickerLabel,
        other.medicalRecordPickerLabel,
        t,
      )!,
      medicalRecordChoice: TextStyle.lerp(
        medicalRecordChoice,
        other.medicalRecordChoice,
        t,
      )!,
      medicalRecordSkip: TextStyle.lerp(
        medicalRecordSkip,
        other.medicalRecordSkip,
        t,
      )!,
    );
  }
}

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
    required this.medicalRecordOptional,
    required this.medicalRecordUploadTitle,
    required this.medicalRecordUploadDescription,
    required this.medicalRecordUploadCardTitle,
    required this.medicalRecordUploadCardDescription,
    required this.medicalRecordSecureNote,
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
  final TextStyle medicalRecordOptional;
  final TextStyle medicalRecordUploadTitle;
  final TextStyle medicalRecordUploadDescription;
  final TextStyle medicalRecordUploadCardTitle;
  final TextStyle medicalRecordUploadCardDescription;
  final TextStyle medicalRecordSecureNote;

  static const mobile = AppTypography(
    hero: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    title: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    body: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    label: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    button: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    medicalRecordQuestion: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
    medicalRecordInput: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
    medicalRecordButton: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
    medicalRecordStep: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    medicalRecordProgress: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    medicalRecordHelper: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
    medicalRecordCancel: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    medicalRecordScreenTitle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordCardTitle: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordPickerLabel: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    medicalRecordChoice: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    medicalRecordSkip: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    medicalRecordOptional: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
    medicalRecordUploadTitle: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordUploadDescription: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    medicalRecordUploadCardTitle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordUploadCardDescription: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    medicalRecordSecureNote: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  );

  static const tablet = AppTypography(
    hero: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
    title: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    body: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
    label: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    button: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    medicalRecordQuestion: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
    medicalRecordInput: TextStyle(fontSize: 21, fontWeight: FontWeight.w400),
    medicalRecordButton: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
    medicalRecordStep: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
    medicalRecordProgress: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
    medicalRecordHelper: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
    medicalRecordCancel: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    medicalRecordScreenTitle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordCardTitle: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordPickerLabel: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    medicalRecordChoice: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    medicalRecordSkip: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    medicalRecordOptional: TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
    medicalRecordUploadTitle: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordUploadDescription: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
    medicalRecordUploadCardTitle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordUploadCardDescription: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    medicalRecordSecureNote: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  );

  static const desktop = AppTypography(
    hero: TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
    title: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    body: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
    label: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
    button: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    medicalRecordQuestion: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
    medicalRecordInput: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
    medicalRecordButton: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
    medicalRecordStep: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
    medicalRecordProgress: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
    medicalRecordHelper: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
    medicalRecordCancel: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    medicalRecordScreenTitle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordCardTitle: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordPickerLabel: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
    medicalRecordChoice: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    medicalRecordSkip: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    medicalRecordOptional: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
    medicalRecordUploadTitle: TextStyle(
      fontSize: 38,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordUploadDescription: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
    ),
    medicalRecordUploadCardTitle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),
    medicalRecordUploadCardDescription: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
    medicalRecordSecureNote: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
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
    TextStyle? medicalRecordOptional,
    TextStyle? medicalRecordUploadTitle,
    TextStyle? medicalRecordUploadDescription,
    TextStyle? medicalRecordUploadCardTitle,
    TextStyle? medicalRecordUploadCardDescription,
    TextStyle? medicalRecordSecureNote,
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
      medicalRecordOptional:
          medicalRecordOptional ?? this.medicalRecordOptional,
      medicalRecordUploadTitle:
          medicalRecordUploadTitle ?? this.medicalRecordUploadTitle,
      medicalRecordUploadDescription:
          medicalRecordUploadDescription ?? this.medicalRecordUploadDescription,
      medicalRecordUploadCardTitle:
          medicalRecordUploadCardTitle ?? this.medicalRecordUploadCardTitle,
      medicalRecordUploadCardDescription:
          medicalRecordUploadCardDescription ??
          this.medicalRecordUploadCardDescription,
      medicalRecordSecureNote:
          medicalRecordSecureNote ?? this.medicalRecordSecureNote,
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
      medicalRecordOptional: TextStyle.lerp(
        medicalRecordOptional,
        other.medicalRecordOptional,
        t,
      )!,
      medicalRecordUploadTitle: TextStyle.lerp(
        medicalRecordUploadTitle,
        other.medicalRecordUploadTitle,
        t,
      )!,
      medicalRecordUploadDescription: TextStyle.lerp(
        medicalRecordUploadDescription,
        other.medicalRecordUploadDescription,
        t,
      )!,
      medicalRecordUploadCardTitle: TextStyle.lerp(
        medicalRecordUploadCardTitle,
        other.medicalRecordUploadCardTitle,
        t,
      )!,
      medicalRecordUploadCardDescription: TextStyle.lerp(
        medicalRecordUploadCardDescription,
        other.medicalRecordUploadCardDescription,
        t,
      )!,
      medicalRecordSecureNote: TextStyle.lerp(
        medicalRecordSecureNote,
        other.medicalRecordSecureNote,
        t,
      )!,
    );
  }
}

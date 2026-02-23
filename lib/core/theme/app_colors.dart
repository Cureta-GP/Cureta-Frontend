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
    required this.medicalRecordBackground,
    required this.medicalRecordHeading,
    required this.medicalRecordMuted,
    required this.medicalRecordProgressText,
    required this.medicalRecordProgressTrack,
    required this.medicalRecordInputHint,
    required this.medicalRecordInputBorder,
    required this.medicalRecordCard,
    required this.medicalRecordAccentSoft,
    required this.medicalRecordStrongText,
    required this.medicalRecordSecondaryStrong,
    required this.medicalRecordOptionBorder,
    required this.medicalRecordUploadCardBorder,
    required this.medicalRecordUploadPrescriptionBg,
    required this.medicalRecordUploadPrescriptionIcon,
    required this.medicalRecordUploadLabBg,
    required this.medicalRecordUploadLabIcon,
    required this.medicalRecordUploadScanBg,
    required this.medicalRecordUploadScanIcon,
    required this.medicalRecordUploadAddButtonBg,
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
  final Color medicalRecordBackground;
  final Color medicalRecordHeading;
  final Color medicalRecordMuted;
  final Color medicalRecordProgressText;
  final Color medicalRecordProgressTrack;
  final Color medicalRecordInputHint;
  final Color medicalRecordInputBorder;
  final Color medicalRecordCard;
  final Color medicalRecordAccentSoft;
  final Color medicalRecordStrongText;
  final Color medicalRecordSecondaryStrong;
  final Color medicalRecordOptionBorder;
  final Color medicalRecordUploadCardBorder;
  final Color medicalRecordUploadPrescriptionBg;
  final Color medicalRecordUploadPrescriptionIcon;
  final Color medicalRecordUploadLabBg;
  final Color medicalRecordUploadLabIcon;
  final Color medicalRecordUploadScanBg;
  final Color medicalRecordUploadScanIcon;
  final Color medicalRecordUploadAddButtonBg;

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
    medicalRecordBackground: Color(0xFFF5F8F8),
    medicalRecordHeading: Color(0xFF111827),
    medicalRecordMuted: Color(0xFF6B7280),
    medicalRecordProgressText: Color(0xFF9CA3AF),
    medicalRecordProgressTrack: Color(0xFFE5E7EB),
    medicalRecordInputHint: Color(0xFF888B93),
    medicalRecordInputBorder: Color(0xFFF2F2F2),
    medicalRecordCard: Color(0xFFFFFFFF),
    medicalRecordAccentSoft: Color(0xFFE5F5F6),
    medicalRecordStrongText: Color(0xFF0C1B1D),
    medicalRecordSecondaryStrong: Color(0xFF4A686A),
    medicalRecordOptionBorder: Color(0xFFF3F4F6),
    medicalRecordUploadCardBorder: Color(0xFFE5E7EB),
    medicalRecordUploadPrescriptionBg: Color(0xFFE7FBFD),
    medicalRecordUploadPrescriptionIcon: Color(0xFF13DDEC),
    medicalRecordUploadLabBg: Color(0xFFFFF7ED),
    medicalRecordUploadLabIcon: Color(0xFFF97316),
    medicalRecordUploadScanBg: Color(0xFFEFF6FF),
    medicalRecordUploadScanIcon: Color(0xFF3B82F6),
    medicalRecordUploadAddButtonBg: Color(0xFFF3F4F6),
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
    medicalRecordBackground: Color(0xFF133A3E),
    medicalRecordHeading: Color(0xFFF5F5F5),
    medicalRecordMuted: Color(0xFFB0BEC5),
    medicalRecordProgressText: Color(0xFF90A4AE),
    medicalRecordProgressTrack: Color(0xFF37474F),
    medicalRecordInputHint: Color(0xFF90A4AE),
    medicalRecordInputBorder: Color(0xFF37474F),
    medicalRecordCard: Color(0xFF1C2328),
    medicalRecordAccentSoft: Color(0xFF2A3D40),
    medicalRecordStrongText: Color(0xFFF5F5F5),
    medicalRecordSecondaryStrong: Color(0xFFB0BEC5),
    medicalRecordOptionBorder: Color(0xFF37474F),
    medicalRecordUploadCardBorder: Color(0xFF37474F),
    medicalRecordUploadPrescriptionBg: Color(0xFF2A3D40),
    medicalRecordUploadPrescriptionIcon: Color(0xFF4DDDE7),
    medicalRecordUploadLabBg: Color(0xFF3D3127),
    medicalRecordUploadLabIcon: Color(0xFFF9A15B),
    medicalRecordUploadScanBg: Color(0xFF223244),
    medicalRecordUploadScanIcon: Color(0xFF70A8F8),
    medicalRecordUploadAddButtonBg: Color(0xFF2A3238),
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
    Color? medicalRecordBackground,
    Color? medicalRecordHeading,
    Color? medicalRecordMuted,
    Color? medicalRecordProgressText,
    Color? medicalRecordProgressTrack,
    Color? medicalRecordInputHint,
    Color? medicalRecordInputBorder,
    Color? medicalRecordCard,
    Color? medicalRecordAccentSoft,
    Color? medicalRecordStrongText,
    Color? medicalRecordSecondaryStrong,
    Color? medicalRecordOptionBorder,
    Color? medicalRecordUploadCardBorder,
    Color? medicalRecordUploadPrescriptionBg,
    Color? medicalRecordUploadPrescriptionIcon,
    Color? medicalRecordUploadLabBg,
    Color? medicalRecordUploadLabIcon,
    Color? medicalRecordUploadScanBg,
    Color? medicalRecordUploadScanIcon,
    Color? medicalRecordUploadAddButtonBg,
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
      medicalRecordBackground:
          medicalRecordBackground ?? this.medicalRecordBackground,
      medicalRecordHeading: medicalRecordHeading ?? this.medicalRecordHeading,
      medicalRecordMuted: medicalRecordMuted ?? this.medicalRecordMuted,
      medicalRecordProgressText:
          medicalRecordProgressText ?? this.medicalRecordProgressText,
      medicalRecordProgressTrack:
          medicalRecordProgressTrack ?? this.medicalRecordProgressTrack,
      medicalRecordInputHint:
          medicalRecordInputHint ?? this.medicalRecordInputHint,
      medicalRecordInputBorder:
          medicalRecordInputBorder ?? this.medicalRecordInputBorder,
      medicalRecordCard: medicalRecordCard ?? this.medicalRecordCard,
      medicalRecordAccentSoft:
          medicalRecordAccentSoft ?? this.medicalRecordAccentSoft,
      medicalRecordStrongText:
          medicalRecordStrongText ?? this.medicalRecordStrongText,
      medicalRecordSecondaryStrong:
          medicalRecordSecondaryStrong ?? this.medicalRecordSecondaryStrong,
      medicalRecordOptionBorder:
          medicalRecordOptionBorder ?? this.medicalRecordOptionBorder,
      medicalRecordUploadCardBorder:
          medicalRecordUploadCardBorder ?? this.medicalRecordUploadCardBorder,
      medicalRecordUploadPrescriptionBg:
          medicalRecordUploadPrescriptionBg ??
          this.medicalRecordUploadPrescriptionBg,
      medicalRecordUploadPrescriptionIcon:
          medicalRecordUploadPrescriptionIcon ??
          this.medicalRecordUploadPrescriptionIcon,
      medicalRecordUploadLabBg:
          medicalRecordUploadLabBg ?? this.medicalRecordUploadLabBg,
      medicalRecordUploadLabIcon:
          medicalRecordUploadLabIcon ?? this.medicalRecordUploadLabIcon,
      medicalRecordUploadScanBg:
          medicalRecordUploadScanBg ?? this.medicalRecordUploadScanBg,
      medicalRecordUploadScanIcon:
          medicalRecordUploadScanIcon ?? this.medicalRecordUploadScanIcon,
      medicalRecordUploadAddButtonBg:
          medicalRecordUploadAddButtonBg ?? this.medicalRecordUploadAddButtonBg,
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
      medicalRecordBackground: Color.lerp(
        medicalRecordBackground,
        other.medicalRecordBackground,
        t,
      )!,
      medicalRecordHeading: Color.lerp(
        medicalRecordHeading,
        other.medicalRecordHeading,
        t,
      )!,
      medicalRecordMuted: Color.lerp(
        medicalRecordMuted,
        other.medicalRecordMuted,
        t,
      )!,
      medicalRecordProgressText: Color.lerp(
        medicalRecordProgressText,
        other.medicalRecordProgressText,
        t,
      )!,
      medicalRecordProgressTrack: Color.lerp(
        medicalRecordProgressTrack,
        other.medicalRecordProgressTrack,
        t,
      )!,
      medicalRecordInputHint: Color.lerp(
        medicalRecordInputHint,
        other.medicalRecordInputHint,
        t,
      )!,
      medicalRecordInputBorder: Color.lerp(
        medicalRecordInputBorder,
        other.medicalRecordInputBorder,
        t,
      )!,
      medicalRecordCard: Color.lerp(
        medicalRecordCard,
        other.medicalRecordCard,
        t,
      )!,
      medicalRecordAccentSoft: Color.lerp(
        medicalRecordAccentSoft,
        other.medicalRecordAccentSoft,
        t,
      )!,
      medicalRecordStrongText: Color.lerp(
        medicalRecordStrongText,
        other.medicalRecordStrongText,
        t,
      )!,
      medicalRecordSecondaryStrong: Color.lerp(
        medicalRecordSecondaryStrong,
        other.medicalRecordSecondaryStrong,
        t,
      )!,
      medicalRecordOptionBorder: Color.lerp(
        medicalRecordOptionBorder,
        other.medicalRecordOptionBorder,
        t,
      )!,
      medicalRecordUploadCardBorder: Color.lerp(
        medicalRecordUploadCardBorder,
        other.medicalRecordUploadCardBorder,
        t,
      )!,
      medicalRecordUploadPrescriptionBg: Color.lerp(
        medicalRecordUploadPrescriptionBg,
        other.medicalRecordUploadPrescriptionBg,
        t,
      )!,
      medicalRecordUploadPrescriptionIcon: Color.lerp(
        medicalRecordUploadPrescriptionIcon,
        other.medicalRecordUploadPrescriptionIcon,
        t,
      )!,
      medicalRecordUploadLabBg: Color.lerp(
        medicalRecordUploadLabBg,
        other.medicalRecordUploadLabBg,
        t,
      )!,
      medicalRecordUploadLabIcon: Color.lerp(
        medicalRecordUploadLabIcon,
        other.medicalRecordUploadLabIcon,
        t,
      )!,
      medicalRecordUploadScanBg: Color.lerp(
        medicalRecordUploadScanBg,
        other.medicalRecordUploadScanBg,
        t,
      )!,
      medicalRecordUploadScanIcon: Color.lerp(
        medicalRecordUploadScanIcon,
        other.medicalRecordUploadScanIcon,
        t,
      )!,
      medicalRecordUploadAddButtonBg: Color.lerp(
        medicalRecordUploadAddButtonBg,
        other.medicalRecordUploadAddButtonBg,
        t,
      )!,
    );
  }
}

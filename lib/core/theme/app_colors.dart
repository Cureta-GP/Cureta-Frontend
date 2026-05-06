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
    required this.success,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.divider,
    required this.icon,
    required this.accentCyan,
    required this.accentOrange,
    required this.accentBlue,
    required this.accentPurple,
    required this.chatBackground,
    required this.statusOnline,
    required this.chatAssistantLabel,
    required this.chatQuickActionBorder,
  });

  final Color primary;
  final Color primaryDark;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color error;
  final Color success;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color divider;
  final Color icon;
  final Color accentCyan;
  final Color accentOrange;
  final Color accentBlue;
  final Color accentPurple;
  final Color chatBackground;
  final Color statusOnline;
  final Color chatAssistantLabel;
  final Color chatQuickActionBorder;

  // --- Light Theme Setup ---
  static final light = AppColors(
    primary: const Color(0xFF00A1A9),
    primaryDark: const Color(0xFF133A3E),
    secondary: const Color(0xFFEDF7F8),
    background: Colors.white,
    surface: const Color(0xFFFAFAFA),
    error: const Color(0xFFB00020),
    success: const Color(0xFF10B981),
    textPrimary: const Color(0xFF212121),
    textSecondary: const Color(0xFF757575),
    textHint: const Color(0xFFBDBDBD),
    divider: const Color(0xFFE0E0E0),
    icon: const Color(0xFF99A1AF),
    accentCyan: const Color(0xFFE0F1F3),
    accentOrange: const Color(0xFFFFEDD5),
    accentBlue: const Color(0xFFE0E7FF),
    accentPurple: const Color(0xFFF5F3FF),
    chatBackground: const Color(0xFFF5F8F8),
    statusOnline: const Color(0xFF10B981),
    chatAssistantLabel: const Color(0xFF33B3B9),
    chatQuickActionBorder: const Color(0xFFCCECED),
  );

  // --- Dark Theme Setup ---
  static final dark = AppColors(
    primary: const Color(0xFF00A1A9),
    primaryDark: const Color(0xFF133A3E),
    secondary: const Color(0xFF1D2B2D),
    background: const Color(0xFF133A3E),
    surface: const Color(0xFF1C2328),
    error: const Color(0xFFCF6679),
    success: const Color(0xFF34D399),
    textPrimary: const Color(0xFFF5F5F5),
    textSecondary: const Color(0xFFB0BEC5),
    textHint: const Color(0xFF90A4AE),
    divider: const Color(0xFF37474F),
    icon: const Color(0xFFB0BEC5),
    accentCyan: const Color(0xFF2A3D40),
    accentOrange: const Color(0xFF3D3127),
    accentBlue: const Color(0xFF223244),
    accentPurple: const Color(0xFF2E1065),
    chatBackground: const Color(0xFF1A2C2E),
    statusOnline: const Color(0xFF34D399),
    chatAssistantLabel: const Color(0xFF5DD5DB),
    chatQuickActionBorder: const Color(0xFF3A5456),
  );

  static AppColors fromBrightness(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryDark,
    Color? secondary,
    Color? background,
    Color? surface,
    Color? error,
    Color? success,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? divider,
    Color? icon,
    Color? accentCyan,
    Color? accentOrange,
    Color? accentBlue,
    Color? accentPurple,
    Color? chatBackground,
    Color? statusOnline,
    Color? chatAssistantLabel,
    Color? chatQuickActionBorder,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      error: error ?? this.error,
      success: success ?? this.success,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      divider: divider ?? this.divider,
      icon: icon ?? this.icon,
      accentCyan: accentCyan ?? this.accentCyan,
      accentOrange: accentOrange ?? this.accentOrange,
      accentBlue: accentBlue ?? this.accentBlue,
      accentPurple: accentPurple ?? this.accentPurple,
      chatBackground: chatBackground ?? this.chatBackground,
      statusOnline: statusOnline ?? this.statusOnline,
      chatAssistantLabel: chatAssistantLabel ?? this.chatAssistantLabel,
      chatQuickActionBorder:
          chatQuickActionBorder ?? this.chatQuickActionBorder,
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
      success: Color.lerp(success, other.success, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      accentCyan: Color.lerp(accentCyan, other.accentCyan, t)!,
      accentOrange: Color.lerp(accentOrange, other.accentOrange, t)!,
      accentBlue: Color.lerp(accentBlue, other.accentBlue, t)!,
      accentPurple: Color.lerp(accentPurple, other.accentPurple, t)!,
      chatBackground: Color.lerp(chatBackground, other.chatBackground, t)!,
      statusOnline: Color.lerp(statusOnline, other.statusOnline, t)!,
      chatAssistantLabel: Color.lerp(
        chatAssistantLabel,
        other.chatAssistantLabel,
        t,
      )!,
      chatQuickActionBorder: Color.lerp(
        chatQuickActionBorder,
        other.chatQuickActionBorder,
        t,
      )!,
    );
  }
}

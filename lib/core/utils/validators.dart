// utils/validators.dart
import 'package:cureta/core/localization/app_localizations.dart';

class Validators {
  // Validate required field
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.fieldRequired(fieldName);
    }
    return null;
  }

  // Validate email
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.emailRequired;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return AppLocalizations.emailInvalid;
    }
    return null;
  }

  // Validate password
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.passwordRequired;
    }

    if (value.length < 6) {
      return AppLocalizations.passwordMinLength;
    }

    if (value.length > 50) {
      return AppLocalizations.passwordMaxLength;
    }

    return null;
  }

  // Validate full name
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.nameRequired;
    }

    if (value.trim().length < 2) {
      return AppLocalizations.nameMinLength;
    }

    return null;
  }

  // Validate phone number (required)
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.phoneRequired;
    }

    final phoneRegex = RegExp(r'^\+?[\d\s-()]+$');

    if (!phoneRegex.hasMatch(value)) {
      return AppLocalizations.phoneInvalid;
    }

    return null;
  }

  // Validate confirm password matches the new password
  static String? confirmPassword(String? value, String? newPassword) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.passwordRequired;
    }
    if (value != newPassword) {
      return AppLocalizations.passwordsNotMatch;
    }
    return null;
  }

  // Strong password validation for sign-up.
  // Rules: ≥8 chars, uppercase, lowercase, digit, special character.
  static String? signupPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.passwordRequired;
    }
    final hasLength = value.length >= 8;
    final hasUpper = value.contains(RegExp(r'[A-Z]'));
    final hasLower = value.contains(RegExp(r'[a-z]'));
    final hasDigit = value.contains(RegExp(r'[0-9]'));
    final hasSpecial = value.contains(
      RegExp(r'[!@#$%^&*(),.?":{}|<>\[\]\\/_ \-+=~`]'),
    );

    if (!hasLength || !hasUpper || !hasLower || !hasDigit || !hasSpecial) {
      return AppLocalizations.passwordWeak;
    }
    return null;
  }
}

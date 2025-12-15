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

  // Validate phone number (optional)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    final phoneRegex = RegExp(r'^\+?[\d\s-()]+$');

    if (!phoneRegex.hasMatch(value)) {
      return AppLocalizations.phoneInvalid;
    }

    return null;
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Helper class for accessing localized strings throughout the app
/// Uses easy_localization package for translation management
class AppLocalizations {
  // App
  static String get appName => 'app.name'.tr();

  // Auth - Login
  static String get loginTitle => 'auth.login.title'.tr();
  static String get emailLabel => 'auth.login.email_label'.tr();
  static String get emailHint => 'auth.login.email_hint'.tr();
  static String get passwordLabel => 'auth.login.password_label'.tr();
  static String get passwordHint => 'auth.login.password_hint'.tr();
  static String get forgotPassword => 'auth.login.forgot_password'.tr();
  static String get loginButton => 'auth.login.login_button'.tr();
  static String get noAccount => 'auth.login.no_account'.tr();
  static String get signupLink => 'auth.login.signup_link'.tr();
  static String get loadingAnimation => 'auth.login.loading_animation'.tr();

  // Auth - Signup
  static String get signupTitle => 'auth.signup.title'.tr();
  static String get signupSubtitle => 'auth.signup.subtitle'.tr();
  static String get nameLabel => 'auth.signup.name_label'.tr();
  static String get nameHint => 'auth.signup.name_hint'.tr();
  static String get signupEmailLabel => 'auth.signup.email_label'.tr();
  static String get signupEmailHint => 'auth.signup.email_hint'.tr();
  static String get signupPasswordLabel => 'auth.signup.password_label'.tr();
  static String get signupPasswordHint => 'auth.signup.password_hint'.tr();
  static String get phoneLabel => 'auth.signup.phone_label'.tr();
  static String get phoneHint => 'auth.signup.phone_hint'.tr();
  static String get signupButton => 'auth.signup.signup_button'.tr();
  static String get haveAccount => 'auth.signup.have_account'.tr();
  static String get loginLink => 'auth.signup.login_link'.tr();

  // Auth - Forgot Password
  static String get forgotPasswordTitle => 'auth.forgot_password.title'.tr();
  static String get forgotPasswordSubtitle =>
      'auth.forgot_password.subtitle'.tr();
  static String get forgotPasswordEmailLabel =>
      'auth.forgot_password.email_label'.tr();
  static String get forgotPasswordEmailHint =>
      'auth.forgot_password.email_hint'.tr();
  static String get sendButton => 'auth.forgot_password.send_button'.tr();
  static String get rememberPassword =>
      'auth.forgot_password.remember_password'.tr();
  static String get backToLogin => 'auth.forgot_password.back_to_login'.tr();

  // Auth - Google
  static String get continueWithGoogle => 'auth.google.continue'.tr();

  // Onboarding
  static String get onboardingScreen1Title => 'onboarding.screen1.title'.tr();
  static String get onboardingScreen1Description =>
      'onboarding.screen1.description'.tr();
  static String get onboardingScreen2Title => 'onboarding.screen2.title'.tr();
  static String get onboardingScreen2Description =>
      'onboarding.screen2.description'.tr();
  static String get onboardingScreen3Title => 'onboarding.screen3.title'.tr();
  static String get onboardingScreen3Description =>
      'onboarding.screen3.description'.tr();
  static String get getStarted => 'onboarding.get_started'.tr();
  static String get skip => 'onboarding.skip'.tr();
  static String get next => 'onboarding.next'.tr();

  // Validation
  static String get emailRequired => 'validation.email_required'.tr();
  static String get emailInvalid => 'validation.email_invalid'.tr();
  static String get passwordRequired => 'validation.password_required'.tr();
  static String get passwordMinLength => 'validation.password_min_length'.tr();
  static String get passwordMaxLength => 'validation.password_max_length'.tr();
  static String get nameRequired => 'validation.name_required'.tr();
  static String get nameMinLength => 'validation.name_min_length'.tr();
  static String get phoneInvalid => 'validation.phone_invalid'.tr();

  // Reset Password
  static String get resetPasswordTitle => 'auth.reset_password.title'.tr();
  static String get resetPasswordSubtitle =>
      'auth.reset_password.subtitle'.tr();
  static String get newPasswordLabel =>
      'auth.reset_password.new_password_label'.tr();
  static String get newPasswordHint =>
      'auth.reset_password.new_password_hint'.tr();
  static String get confirmPasswordLabel =>
      'auth.reset_password.confirm_password_label'.tr();
  static String get confirmPasswordHint =>
      'auth.reset_password.confirm_password_hint'.tr();
  static String get resetPasswordButton =>
      'auth.reset_password.reset_button'.tr();

  // Email Verification
  static String get verifyEmailTitle => 'auth.verify_email.title'.tr();
  static String get verifyEmailSubtitle => 'auth.verify_email.subtitle'.tr();
  static String get verifyEmailSent => 'auth.verify_email.sent'.tr();
  static String get verifyButton => 'auth.verify_email.verify_button'.tr();
  static String get otpError => 'auth.verify_email.otp_error'.tr();

  static String fieldRequired(String field) =>
      'validation.field_required'.tr(namedArgs: {'field': field});

  // Helper methods
  static bool isRTL(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }

  static Locale get currentLocale =>
      EasyLocalization.of(BuildContext as BuildContext)!.locale;
}

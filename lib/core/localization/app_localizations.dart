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

  static String get onboardingScreen4Title => 'onboarding.screen4.title'.tr();
  static String get onboardingScreen4Description =>
      'onboarding.screen4.description'.tr();

  static String get onboardingScreen5Title => 'onboarding.screen5.title'.tr();
  static String get onboardingScreen5Description =>
      'onboarding.screen5.description'.tr();

  static String get onboardingScreen6Title => 'onboarding.screen6.title'.tr();
  static String get onboardingScreen6Description =>
      'onboarding.screen6.description'.tr();

  static String get onboardingScreen7Title => 'onboarding.screen7.title'.tr();
  static String get onboardingScreen7Description =>
      'onboarding.screen7.description'.tr();

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

  // Medical Records - Add Record Step 1
  static String get addRecordCancel => 'medical_records.add_record.cancel'.tr();
  static String get addRecordStepLabel =>
      'medical_records.add_record.step_1_label'.tr();
  static String get addRecordProgressLabel =>
      'medical_records.add_record.progress_20'.tr();
  static String get addRecordConditionQuestion =>
      'medical_records.add_record.condition_question'.tr();
  static String get addRecordTypeHint =>
      'medical_records.add_record.type_here_hint'.tr();
  static String get addRecordConditionExample =>
      'medical_records.add_record.condition_example'.tr();
  static String get addRecordNext => 'medical_records.add_record.next'.tr();
  static String get addRecordBasicInfoTitle =>
      'medical_records.add_record.basic_information_title'.tr();
  static String get addRecordStep2Label =>
      'medical_records.add_record.step_2_label'.tr();
  static String get addRecordStep3Label =>
      'medical_records.add_record.step_3_label'.tr();
  static String get addRecordStep4Label =>
      'medical_records.add_record.step_4_label'.tr();
  static String get addRecordStep5Label =>
      'medical_records.add_record.step_5_label'.tr();
  static String get addRecordProgress40 =>
      'medical_records.add_record.progress_40'.tr();
  static String get addRecordProgress60 =>
      'medical_records.add_record.progress_60'.tr();
  static String get addRecordProgress80 =>
      'medical_records.add_record.progress_80'.tr();
  static String get addRecordProgress100 =>
      'medical_records.add_record.progress_100'.tr();
  static String get addRecordFirstSymptomsQuestion =>
      'medical_records.add_record.first_symptoms_question'.tr();
  static String get addRecordSelectDate =>
      'medical_records.add_record.select_date'.tr();
  static String get addRecordOngoingQuestion =>
      'medical_records.add_record.ongoing_question'.tr();
  static String get addRecordYes => 'medical_records.add_record.yes'.tr();
  static String get addRecordNo => 'medical_records.add_record.no'.tr();
  static String get addRecordNextStep =>
      'medical_records.add_record.next_step'.tr();
  static String get addRecordSkipForNow =>
      'medical_records.add_record.skip_for_now'.tr();
  static String get addRecordOptional =>
      'medical_records.add_record.optional'.tr();
  static String get addRecordRelatedFilesTitle =>
      'medical_records.add_record.related_files_title'.tr();
  static String get addRecordRelatedFilesDescription =>
      'medical_records.add_record.related_files_description'.tr();
  static String get addRecordPrescriptionTitle =>
      'medical_records.add_record.prescription_title'.tr();
  static String get addRecordPrescriptionDescription =>
      'medical_records.add_record.prescription_description'.tr();
  static String get addRecordLabTestTitle =>
      'medical_records.add_record.lab_test_title'.tr();
  static String get addRecordLabTestDescription =>
      'medical_records.add_record.lab_test_description'.tr();
  static String get addRecordScanTitle =>
      'medical_records.add_record.scan_title'.tr();
  static String get addRecordScanDescription =>
      'medical_records.add_record.scan_description'.tr();
  static String get addRecordAdditionalNotesTitle =>
      'medical_records.add_record.additional_notes_title'.tr();
  static String get addRecordAdditionalNotesDescription =>
      'medical_records.add_record.additional_notes_description'.tr();
  static String get addRecordOptionalNotesHint =>
      'medical_records.add_record.optional_notes_hint'.tr();
  static String get addRecordDataSecureNote =>
      'medical_records.add_record.data_secure_note'.tr();
  static String get addRecordReviewDetailsTitle =>
      'medical_records.add_record.review_details_title'.tr();
  static String get addRecordReviewQuestion =>
      'medical_records.add_record.review_question'.tr();
  static String get addRecordReviewDescription =>
      'medical_records.add_record.review_description'.tr();
  static String get addRecordReviewCondition =>
      'medical_records.add_record.review_condition'.tr();
  static String get addRecordReviewStartedOn =>
      'medical_records.add_record.review_started_on'.tr();
  static String get addRecordReviewDocuments =>
      'medical_records.add_record.review_documents'.tr();
  static String addRecordReviewReports(int count) =>
      'medical_records.add_record.review_reports'.tr(
        namedArgs: {'count': '$count'},
      );
  static String get addRecordReviewDocumentsAttached =>
      'medical_records.add_record.review_documents_attached'.tr();
  static String get addRecordSaveRecord =>
      'medical_records.add_record.save_record'.tr();
  static String get addRecordContinue =>
      'medical_records.add_record.continue'.tr();

  // Medical Records - List Screen
  static String get recordsListTitle => 'medical_records.list.title'.tr();
  static String get recordsListSearchHint =>
      'medical_records.list.search_hint'.tr();
  static String get recordsListFilterAll =>
      'medical_records.list.filter_all'.tr();
  static String get recordsListFilterOngoing =>
      'medical_records.list.filter_ongoing'.tr();
  static String get recordsListFilterPast =>
      'medical_records.list.filter_past'.tr();
  static String get recordsListFilterRecent =>
      'medical_records.list.filter_recent'.tr();
  static String get recordsListStatusOngoing =>
      'medical_records.list.status_ongoing'.tr();
  static String get recordsListStatusPast =>
      'medical_records.list.status_past'.tr();
  static String get recordsListType2Diabetes =>
      'medical_records.list.record_type2diabetes'.tr();
  static String get recordsListType2DiabetesMeta =>
      'medical_records.list.record_type2diabetes_meta'.tr();
  static String get recordsListAcuteBronchitis =>
      'medical_records.list.record_acute_bronchitis'.tr();
  static String get recordsListAcuteBronchitisMeta =>
      'medical_records.list.record_acute_bronchitis_meta'.tr();
  static String get recordsListHypertension =>
      'medical_records.list.record_hypertension'.tr();
  static String get recordsListHypertensionMeta =>
      'medical_records.list.record_hypertension_meta'.tr();
  static String get recordsListSeasonalAllergies =>
      'medical_records.list.record_seasonal_allergies'.tr();
  static String get recordsListSeasonalAllergiesMeta =>
      'medical_records.list.record_seasonal_allergies_meta'.tr();
  static String get recordsListNavHome => 'medical_records.list.nav_home'.tr();
  static String get recordsListNavMeds => 'medical_records.list.nav_meds'.tr();
  static String get recordsListNavScanRx =>
      'medical_records.list.nav_scan_rx'.tr();
  static String get recordsListNavRecords =>
      'medical_records.list.nav_records'.tr();
  static String get recordsListNavProfile =>
      'medical_records.list.nav_profile'.tr();

  static String fieldRequired(String field) =>
      'validation.field_required'.tr(namedArgs: {'field': field});

  // Helper methods
  static bool isRTL(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }

  static Locale get currentLocale =>
      EasyLocalization.of(BuildContext as BuildContext)!.locale;
}

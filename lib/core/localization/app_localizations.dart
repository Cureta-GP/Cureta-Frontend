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

  // Select Profile
  static String get selectProfileTitle => 'auth.select_profile.title'.tr();
  static String get selectProfileSubtitle =>
      'auth.select_profile.subtitle'.tr();
  static String get selectProfilePrimaryAccount =>
      'auth.select_profile.primary_account'.tr();
  static String get selectProfileSecondary =>
      'auth.select_profile.secondary'.tr();
  static String get selectProfileSpouse => 'auth.select_profile.spouse'.tr();
  static String get selectProfileSon => 'auth.select_profile.son'.tr();
  static String get selectProfileDaughter =>
      'auth.select_profile.daughter'.tr();
  static String get selectProfileParent => 'auth.select_profile.parent'.tr();
  static String get selectProfileAddProfile =>
      'auth.select_profile.add_profile'.tr();

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

  // Medical Records - Record Details Screen
  static String get recordDetailsTitle => 'medical_records.details.title'.tr();
  static String get recordDetailsStatusOngoing =>
      'medical_records.details.status_ongoing'.tr();
  static String get recordDetailsDiagnosedOn =>
      'medical_records.details.diagnosed_on'.tr();
  static String get recordDetailsNotesTitle =>
      'medical_records.details.notes_title'.tr();
  static String get recordDetailsDocumentsTitle =>
      'medical_records.details.documents_title'.tr();
  static String get recordDetailsViewAll =>
      'medical_records.details.view_all'.tr();
  static String get recordDetailsEditRecord =>
      'medical_records.details.edit_record'.tr();
  static String get recordDetailsDeleteRecord =>
      'medical_records.details.delete_record'.tr();
  static String get recordDetailsConditionRequired =>
      'medical_records.details.condition_required'.tr();
  static String get recordDetailsRemoveAttachmentsHint =>
      'medical_records.details.remove_attachments_hint'.tr();
  static String get recordDetailsRemoveAttachment =>
      'medical_records.details.remove_attachment'.tr();
  static String get recordDetailsFileUrlMissing =>
      'medical_records.details.file_url_missing'.tr();
  static String get recordDetailsInvalidFileUrl =>
      'medical_records.details.invalid_file_url'.tr();
  static String get recordDetailsOpenAttachmentError =>
      'medical_records.details.open_attachment_error'.tr();
  static String get recordDetailsDeleteUnavailable =>
      'medical_records.details.delete_unavailable'.tr();
  static String get recordDetailsEditUnavailable =>
      'medical_records.details.edit_unavailable'.tr();
  static String get recordDetailsDeleteSuccess =>
      'medical_records.details.delete_success'.tr();
  static String get recordDetailsUpdateSuccess =>
      'medical_records.details.update_success'.tr();
  static String get recordDetailsDeleteFailed =>
      'medical_records.details.delete_failed'.tr();
  static String get recordDetailsUpdateFailed =>
      'medical_records.details.update_failed'.tr();
  static String get recordDetailsDeleteConfirmTitle =>
      'medical_records.details.delete_confirm_title'.tr();
  static String recordDetailsDeleteConfirmMessage(String condition) =>
      'medical_records.details.delete_confirm_message'.tr(
        namedArgs: {'condition': condition},
      );

  static String fieldRequired(String field) =>
      'validation.field_required'.tr(namedArgs: {'field': field});
  // Family profiles
  static String get profilesAddProfile => 'profiles.common.add_profile'.tr();
  static String get profilesNextStep => 'profiles.common.next_step'.tr();
  static String get profilesContinue => 'profiles.common.continue'.tr();
  static String get profilesSkipForNow => 'profiles.common.skip_for_now'.tr();
  static String profilesStepIndicator(int current, int total) =>
      'profiles.common.step_indicator'.tr(
        args: [current.toString(), total.toString()],
      );

  static String get profilesNameTitle => 'profiles.steps.name.title'.tr();
  static String get profilesNameSubtitle => 'profiles.steps.name.subtitle'.tr();
  static String get profilesNameHint => 'profiles.steps.name.hint'.tr();

  static String get profilesGenderTitle => 'profiles.steps.gender.title'.tr();
  static String get profilesGenderSubtitle =>
      'profiles.steps.gender.subtitle'.tr();
  static String get profilesGenderMale => 'profiles.steps.gender.male'.tr();
  static String get profilesGenderFemale => 'profiles.steps.gender.female'.tr();

  static String get profilesRelationTitle =>
      'profiles.steps.relation.title'.tr();
  static String get profilesRelationSubtitle =>
      'profiles.steps.relation.subtitle'.tr();
  static String get profilesRelationSon => 'profiles.steps.relation.son'.tr();
  static String get profilesRelationDaughter =>
      'profiles.steps.relation.daughter'.tr();
  static String get profilesRelationMother =>
      'profiles.steps.relation.mother'.tr();
  static String get profilesRelationFather =>
      'profiles.steps.relation.father'.tr();
  static String get profilesRelationSpouse =>
      'profiles.steps.relation.spouse'.tr();
  static String get profilesRelationOther =>
      'profiles.steps.relation.other'.tr();

  static String get profilesAgeTitle => 'profiles.steps.age.title'.tr();
  static String get profilesAgeSubtitle => 'profiles.steps.age.subtitle'.tr();

  static String get profilesBloodTypeTitle =>
      'profiles.steps.blood_type.title'.tr();
  static String get profilesBloodTypeSubtitle =>
      'profiles.steps.blood_type.subtitle'.tr();
  static String get profilesBloodTypeFooter =>
      'profiles.steps.blood_type.footer_note'.tr();

  static String get profilesMedicalConditionsChronicTitle =>
      'profiles.steps.medical_conditions_chronic.title'.tr();

  static String get profilesMedicalConditionsAllergiesTitle =>
      'profiles.steps.medical_conditions_allergies.title'.tr();

  static String get profilesMedicalConditionsChronicSubtitle =>
      'profiles.steps.medical_conditions_chronic.subtitle'.tr();

  static String get profilesMedicalConditionsAllergiesSubtitle =>
      'profiles.steps.medical_conditions_allergies.subtitle'.tr();

  static String get profilesMedicalConditionsSubtitle =>
      'profiles.steps.medical_conditions.subtitle'.tr();

  static String get profilesMedicalConditionsDiabetes =>
      'profiles.steps.medical_conditions.diabetes'.tr();
  static String get profilesMedicalConditionsHypertension =>
      'profiles.steps.medical_conditions.hypertension'.tr();
  static String get profilesMedicalConditionsHeartDisease =>
      'profiles.steps.medical_conditions.heart_disease'.tr();
  static String get profilesMedicalConditionsAsthma =>
      'profiles.steps.medical_conditions.asthma'.tr();
  static String get profilesMedicalConditionsThyroid =>
      'profiles.steps.medical_conditions.thyroid'.tr();
  static String get profilesMedicalConditionsArthritis =>
      'profiles.steps.medical_conditions.arthritis'.tr();
  static String get profilesMedicalConditionsFood =>
      'profiles.steps.medical_conditions.food'.tr();
  static String get profilesMedicalConditionsDairy =>
      'profiles.steps.medical_conditions.dairy'.tr();
  static String get profilesMedicalConditionsDrug =>
      'profiles.steps.medical_conditions.drug'.tr();
  static String get profilesMedicalConditionsRespiratory =>
      'profiles.steps.medical_conditions.respiratory'.tr();
  static String get profilesMedicalConditionsSkin =>
      'profiles.steps.medical_conditions.skin'.tr();
  static String get profilesMedicalConditionsInsect =>
      'profiles.steps.medical_conditions.insect'.tr();
  static String get profilesMedicalConditionsPet =>
      'profiles.steps.medical_conditions.pet'.tr();
  static String get profilesMedicalConditionsNoAllergy =>
      'profiles.steps.medical_conditions.no_allergy'.tr();
  static String get profilesMedicalConditionsOther =>
      'profiles.steps.medical_conditions.other'.tr();

  // Helper methods
  static bool isRTL(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }

  static Locale currentLocale(BuildContext context) =>
      EasyLocalization.of(context)!.locale;

  // Home
  static String get homeWelcomeBack => 'home.welcome_back'.tr();
  static String get homeAddRecord => 'home.add_record'.tr();
  static String get homeAddAlert => 'home.add_alert'.tr();
  static String get homeMyQrCode => 'home.my_qr_code'.tr();
  static String get homeUpcomingMeds => 'home.upcoming_meds'.tr();
  static String get homeSeeAll => 'home.see_all'.tr();
  static String get homeRecentActivity => 'home.recent_activity'.tr();
  static String get homeAddedYesterday => 'home.added_yesterday'.tr();
  static String homeAddedDaysAgo(int days) =>
      'home.added_days_ago'.tr(namedArgs: {'days': days.toString()});
  static String get homeAmoxicillin => 'home.amoxicillin'.tr();
  static String get homeAmoxicillinNote => 'home.amoxicillin_note'.tr();
  static String get homeVitaminD => 'home.vitamin_d'.tr();
  static String get homeVitaminDNote => 'home.vitamin_d_note'.tr();
  static String get homeBloodTestResults => 'home.blood_test_results'.tr();
  static String get homeVaccinationRecord => 'home.vaccination_record'.tr();
  static String? get chatInputHint => 'chat.input_hint'.tr();
  static String get chatAssistantTitle => 'chat.assistant_title'.tr();
  static String get chatOnlineStatus => 'chat.online_status'.tr();
  static String get chatThinkingStatus => 'chat.thinking_status'.tr();
  static String get chatAssistantSender => 'chat.assistant_sender'.tr();
  static String get chatUserSender => 'chat.user_sender'.tr();
  static String get chatGreetingMessage => 'chat.greeting_message'.tr();
  static String get chatUserQuestion => 'chat.user_question'.tr();
  static String get chatReplyMessage => 'chat.reply_message'.tr();

  // Medicines
  static String get medicinesSuccessTitle => 'medicines.success_title'.tr();
  static String get medicinesSuccessSubtitle => 'medicines.success_subtitle'.tr();
  static String get medicinesGoToMyMedicines => 'medicines.go_to_my_medicines'.tr();
  static String get medicinesStep1Of5 => 'medicines.step_1_of_5'.tr();
  static String get medicinesStep1Progress => 'medicines.step_1_progress'.tr();
  static String get medicinesStep1Question => 'medicines.step_1_question'.tr();
  static String get medicinesStep1Subtitle => 'medicines.step_1_subtitle'.tr();
  static String get medicinesMedicineNameHint => 'medicines.medicine_name_hint'.tr();
  static String get medicinesStep1InfoHint => 'medicines.step_1_info_hint'.tr();
  static String get medicinesAddMedicine => 'medicines.add_medicine'.tr();
  static String get medicinesStep4Of5 => 'medicines.step_4_of_5'.tr();
  static String get medicinesStep4Progress => 'medicines.step_4_progress'.tr();
  static String get medicinesStep4Question => 'medicines.step4_question'.tr();
  static String get medicinesStep4Helper => 'medicines.step4_helper'.tr();
  static String get medicinesSaveReminder => 'medicines.save_reminder'.tr();
  static String get medicinesSkipForNow => 'medicines.skip_for_now'.tr();
  static String get medicinesStep2Of5 => 'medicines.step_2_of_5'.tr();
  static String get medicinesStep2Progress => 'medicines.step_2_progress'.tr();
  static String get medicinesStep2Question => 'medicines.step_2_question'.tr();
  static String get medicinesDoseFormLabel => 'medicines.dose_form_label'.tr();
  static String get medicinesFrequencyLabel => 'medicines.frequency_label'.tr();
  static String get medicinesStep3Of5 => 'medicines.step_3_of_5'.tr();
  static String get medicinesStep3Progress => 'medicines.step_3_progress'.tr();
  static String get medicinesStep3Question => 'medicines.step_3_question'.tr();
  static String get medicinesAlarmTimesLabel => 'medicines.alarm_times_label'.tr();
  static String get medicinesAddAlarmTime => 'medicines.add_alarm_time'.tr();
  static String get medicinesNotesLabel => 'medicines.notes_label'.tr();
  static String get medicinesNotesHint => 'medicines.notes_hint'.tr();
  static String get medicinesMyMedicines => 'medicines.my_medicines'.tr();
  static String get medicinesEmptyMedicinesTitle => 'medicines.empty_medicines_title'.tr();
  static String get medicinesEmptyMedicinesSubtitle => 'medicines.empty_medicines_subtitle'.tr();
  static String get medicinesAddYourFirstMedicine => 'medicines.add_your_first_medicine'.tr();
  static String get medicinesSearchHint => 'medicines.search_hint'.tr();
  static String get medicinesFilterAll => 'medicines.filter_all'.tr();
  static String get medicinesFilterActive => 'medicines.filter_active'.tr();
  static String get medicinesFilterPaused => 'medicines.filter_paused'.tr();
  static String get medicinesRetry => 'medicines.retry'.tr();
  static String get medicinesEditDetails => 'medicines.edit_details'.tr();
  static String get medicinesPickImageTitle => 'medicines.pick_image_title'.tr();
  static String get medicinesPickFromCamera => 'medicines.pick_from_camera'.tr();
  static String get medicinesPickFromGallery => 'medicines.pick_from_gallery'.tr();
  static String get medicinesAlarmTaken => 'medicines.alarm_taken'.tr();
  static String get medicinesAlarmMissed => 'medicines.alarm_missed'.tr();
  static String get medicinesAlarmSubtitle => 'medicines.alarm_subtitle'.tr();
  static String dynamicTr(String key) => key.tr();
}

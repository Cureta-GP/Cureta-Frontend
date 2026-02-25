import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/widgets/add_record_screen_header.dart';
import 'package:cureta/features/medical_records/widgets/add_record_secure_note.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_two_bottom_bar.dart';
import 'package:cureta/features/medical_records/widgets/add_record_upload_category_tile.dart';
import 'package:cureta/features/medical_records/widgets/add_record_upload_section_header.dart';
import 'package:cureta/shared/widgets/add_record_step_progress.dart';
import 'package:flutter/material.dart';

class AddRecordStepFourBody extends StatelessWidget {
  const AddRecordStepFourBody({
    super.key,
    this.onBack,
    this.onContinue,
    this.onSkip,
    this.onPrescriptionTap,
    this.onLabTestTap,
    this.onScanTap,
  });

  final VoidCallback? onBack;
  final VoidCallback? onContinue;
  final VoidCallback? onSkip;
  final VoidCallback? onPrescriptionTap;
  final VoidCallback? onLabTestTap;
  final VoidCallback? onScanTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Column(
      children: [
        AddRecordScreenHeader(
          title: AppLocalizations.addRecordStep4Label,
          onBack: onBack,
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: spacing.lg),
            children: [
              AddRecordStepProgress(
                stepLabel: AppLocalizations.addRecordStep4Label,
                progressLabel: AppLocalizations.addRecordProgress80,
                progress: 0.8,
              ),
              SizedBox(height: spacing.xl),
              const AddRecordUploadSectionHeader(),
              SizedBox(height: spacing.xxl),
              AddRecordUploadCategoryTile(
                icon: Icons.receipt_long,
                iconBackgroundColor: colors.medicalRecordUploadPrescriptionBg,
                iconColor: colors.medicalRecordUploadPrescriptionIcon,
                title: AppLocalizations.addRecordPrescriptionTitle,
                description: AppLocalizations.addRecordPrescriptionDescription,
                onTap: onPrescriptionTap,
              ),
              SizedBox(height: spacing.md),
              AddRecordUploadCategoryTile(
                icon: Icons.science_outlined,
                iconBackgroundColor: colors.medicalRecordUploadLabBg,
                iconColor: colors.medicalRecordUploadLabIcon,
                title: AppLocalizations.addRecordLabTestTitle,
                description: AppLocalizations.addRecordLabTestDescription,
                onTap: onLabTestTap,
              ),
              SizedBox(height: spacing.md),
              AddRecordUploadCategoryTile(
                icon: Icons.image_search_outlined,
                iconBackgroundColor: colors.medicalRecordUploadScanBg,
                iconColor: colors.medicalRecordUploadScanIcon,
                title: AppLocalizations.addRecordScanTitle,
                description: AppLocalizations.addRecordScanDescription,
                onTap: onScanTap,
              ),
              SizedBox(height: spacing.xxl),
              const AddRecordSecureNote(),
              SizedBox(height: spacing.xl),
              AddRecordStepTwoBottomBar(
                onNext: onContinue,
                onSkip: onSkip,
                nextLabel: AppLocalizations.addRecordContinue,
              ),
              //SizedBox(height: spacing.xl),
            ],
          ),
        ),
      ],
    );
  }
}

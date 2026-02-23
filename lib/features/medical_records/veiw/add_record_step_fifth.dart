import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/widgets/add_record_review_documents_tile.dart';
import 'package:cureta/features/medical_records/widgets/add_record_review_item.dart';
import 'package:cureta/features/medical_records/widgets/add_record_screen_header.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_progress.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_two_bottom_bar.dart';
import 'package:flutter/material.dart';

class AddRecordStepFifth extends StatelessWidget {
  const AddRecordStepFifth({
    super.key,
    this.onBack,
    this.onCancel,
    this.onSave,
    this.condition = 'Migraine',
    this.startedOn,
    this.documentsCount = 3,
  });

  final VoidCallback? onBack;
  final VoidCallback? onCancel;
  final VoidCallback? onSave;
  final String condition;
  final DateTime? startedOn;
  final int documentsCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    final startedDate = startedOn ?? DateTime(2023, 8, 12);
    final startedDateLabel = MaterialLocalizations.of(
      context,
    ).formatMediumDate(startedDate);

    return Scaffold(
      backgroundColor: colors.medicalRecordBackground,
      body: SafeArea(
        child: Column(
          children: [
            AddRecordScreenHeader(
              title: AppLocalizations.addRecordReviewDetailsTitle,
              onBack: onBack,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                children: [
                  AddRecordStepProgress(
                    stepLabel: AppLocalizations.addRecordStep5Label,
                    progressLabel: AppLocalizations.addRecordProgress100,
                    progress: 1,
                  ),
                  SizedBox(height: spacing.xxl),
                  Text(
                    AppLocalizations.addRecordReviewQuestion,
                    textAlign: TextAlign.center,
                    style: typography.medicalRecordQuestion.copyWith(
                      color: colors.medicalRecordStrongText,
                    ),
                  ),
                  SizedBox(height: spacing.sm),
                  Text(
                    AppLocalizations.addRecordReviewDescription,
                    textAlign: TextAlign.center,
                    style: typography.medicalRecordHelper.copyWith(
                      color: colors.medicalRecordMuted,
                    ),
                  ),
                  SizedBox(height: spacing.xl),
                  Container(
                    padding: EdgeInsets.all(spacing.xl),
                    decoration: BoxDecoration(
                      color: colors.medicalRecordCard,
                      borderRadius: BorderRadius.circular(radius.xxl),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AddRecordReviewItem(
                          label: AppLocalizations.addRecordReviewCondition,
                          value: condition,
                        ),
                        SizedBox(height: spacing.md),
                        AddRecordReviewItem(
                          label: AppLocalizations.addRecordReviewStartedOn,
                          value: startedDateLabel,
                        ),
                        SizedBox(height: spacing.md),
                        Text(
                          AppLocalizations.addRecordReviewDocuments,
                          style: typography.medicalRecordHelper.copyWith(
                            color: colors.medicalRecordProgressText,
                          ),
                        ),
                        SizedBox(height: spacing.sm),
                        AddRecordReviewDocumentsTile(
                          documentsCount: documentsCount,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacing.xl),
                  AddRecordStepTwoBottomBar(
                    onNext: onSave,
                    onSkip: onCancel,
                    nextLabel: AppLocalizations.addRecordSaveRecord,
                  ),
                  //SizedBox(height: spacing.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

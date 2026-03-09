import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_form_cubit.dart';
import 'package:cureta/features/medical_records/widgets/add_record_review_card.dart';
import 'package:cureta/features/medical_records/widgets/add_record_review_submit_section.dart';
import 'package:cureta/features/medical_records/widgets/add_record_screen_header.dart';
import 'package:cureta/shared/widgets/add_record_step_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddRecordStepFifth extends StatelessWidget {
  const AddRecordStepFifth({
    super.key,
    this.onBack,
    this.onCancel,
    this.onSave,
  });

  final VoidCallback? onBack;
  final VoidCallback? onCancel;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    // Read form state once (it's finalized at step 5)
    final formState = context.read<AddRecordFormCubit>().state;
    return  Scaffold(
        backgroundColor: colors.background,
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
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: spacing.sm),
                    Text(
                      AppLocalizations.addRecordReviewDescription,
                      textAlign: TextAlign.center,
                      style: typography.medicalRecordHelper.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: spacing.xl),
                    // Extracted widget - reads form state once
                    AddRecordReviewCard(
                      condition: formState.diseaseName ?? 'Migraine',
                      recordDate: formState.recordDate,
                    ),
                    SizedBox(height: spacing.xl),
                    // Extracted widget - only rebuilds on loading state change
                    AddRecordReviewSubmitSection(
                      formState: formState,
                      onSave: onSave,
                      onCancel: onCancel,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}

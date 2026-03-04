import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_step_four_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_step_four_state.dart';
import 'package:cureta/features/medical_records/widgets/add_record_review_documents_tile.dart';
import 'package:cureta/features/medical_records/widgets/add_record_review_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Displays the review card with condition, date, and document count.
/// Uses BlocSelector to only rebuild when document count changes.
class AddRecordReviewCard extends StatelessWidget {
  const AddRecordReviewCard({
    super.key,
    required this.condition,
    required this.recordDate,
  });

  final String condition;
  final DateTime? recordDate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    final startedDate = recordDate ?? DateTime(2023, 8, 12);
    final startedDateLabel = MaterialLocalizations.of(
      context,
    ).formatMediumDate(startedDate);

    return Container(
      padding: EdgeInsets.all(spacing.xl),
      decoration: BoxDecoration(
        color: colors.surface,
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
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: spacing.sm),
          // Use BlocSelector - only rebuilds when document count changes
          BlocSelector<AddRecordStepFourCubit, AddRecordStepFourState, int>(
            selector: (state) =>
                state.prescriptionFiles.length +
                state.labTestFiles.length +
                state.scanFiles.length +
                state.reportFiles.length +
                state.otherFiles.length,
            builder: (context, documentsCount) {
              return AddRecordReviewDocumentsTile(
                documentsCount: documentsCount,
              );
            },
          ),
        ],
      ),
    );
  }
}

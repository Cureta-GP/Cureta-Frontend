import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import '../data/models/medication_timeline_model.dart';

class ReportMedicationBarWidget extends StatelessWidget {
  const ReportMedicationBarWidget({super.key, required this.medication});

  final MedicationTimelineModel medication;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final radius = context.radius;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: spacing.lg),
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius.lg),
        border: Border.all(color: colors.divider, width: spacing.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  medication.name,
                  style: typography.medicalRecordDetailBody.copyWith(
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: spacing.sm),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colors.secondary,
                  borderRadius: BorderRadius.circular(radius.full),
                ),
                child: Text(
                  'Ongoing',
                  style: typography.medicalRecordProgress.copyWith(
                    color: colors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(radius.full),
            child: LinearProgressIndicator(
              value: medication.progress / 100,
              minHeight: spacing.xs,
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
              backgroundColor: colors.secondary,
            ),
          ),
          SizedBox(height: spacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  medication.instruction?.isNotEmpty == true
                      ? medication.instruction!
                      : medication.name,
                  style: typography.label.copyWith(color: colors.textHint),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: spacing.sm),
              Text(
                '${medication.progress}%',
                style: typography.medicalRecordProgress.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

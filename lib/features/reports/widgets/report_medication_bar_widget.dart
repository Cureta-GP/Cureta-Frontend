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

    return Column(
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
              ),
            ),
            Text(
              '${medication.progress}%',
              style: typography.medicalRecordProgress.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(radius.full),
          child: LinearProgressIndicator(
            value: medication.progress / 100,
            minHeight: spacing.xs,
            valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            backgroundColor: colors.secondary,
          ),
        ),
        if (medication.instruction != null &&
            medication.instruction!.isNotEmpty) ...[
          SizedBox(height: spacing.xs / 2),
          Text(
            medication.instruction!,
            style: typography.label.copyWith(color: colors.textHint),
          ),
        ],
        SizedBox(height: spacing.lg),
      ],
    );
  }
}

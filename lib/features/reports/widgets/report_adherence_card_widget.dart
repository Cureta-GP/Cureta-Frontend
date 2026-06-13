import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import '../data/models/adherence_summary_model.dart';

class ReportAdherenceCardWidget extends StatelessWidget {
  const ReportAdherenceCardWidget({super.key, required this.adherence});

  final AdherenceSummaryModel adherence;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final radius = context.radius;

    return Container(
      padding: EdgeInsets.all(spacing.xl),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius.lg),
        border: Border.all(color: colors.divider, width: spacing.hairline),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: adherence.overallPercentage / 100,
                  strokeWidth: 8,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                  backgroundColor: colors.divider,
                ),
                Text(
                  '${adherence.overallPercentage}%',
                  style: typography.medicalRecordStep.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: spacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'reports.adherence_rate'.tr(),
                  style: typography.medicalRecordDetailLabel.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  '${adherence.activeMeds} ${'reports.active_meds'.tr()}',
                  style: typography.medicalRecordScreenTitle.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

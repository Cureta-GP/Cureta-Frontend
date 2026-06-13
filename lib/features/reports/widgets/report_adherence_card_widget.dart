import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import '../data/models/adherence_summary_model.dart';

class ReportAdherenceCardWidget extends StatelessWidget {
  const ReportAdherenceCardWidget({
    super.key,
    required this.adherence,
    this.status,
  });

  final AdherenceSummaryModel adherence;
  final String? status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;

    return Container(
      padding: EdgeInsets.all(spacing.xl),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius.lg),
        border: Border.all(color: colors.divider, width: spacing.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(radius.full),
            child: LinearProgressIndicator(
              value: adherence.overallPercentage / 100,
              minHeight: spacing.xs,
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
              backgroundColor: colors.divider,
            ),
          ),
          SizedBox(height: spacing.lg),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'reports.active_meds'.tr(),
                  value: '${adherence.activeMeds}',
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: _MetricTile(
                  label: 'reports.lab_results'.tr(),
                  value: status?.isNotEmpty == true
                      ? status!
                      : '${adherence.overallPercentage}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final radius = context.radius;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: BorderRadius.circular(radius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: typography.medicalRecordDetailLabel.copyWith(
              color: colors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: spacing.xs),
          Text(
            value,
            style: typography.medicalRecordScreenTitle.copyWith(
              color: colors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import '../data/models/health_report_model.dart';

class ReportHistoryCardWidget extends StatelessWidget {
  const ReportHistoryCardWidget({
    super.key,
    required this.report,
    required this.onTap,
  });

  final HealthReportModel report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final radius = context.radius;

    final formattedDate = report.createdAt != null
        ? DateFormat('dd MMM yyyy').format(report.createdAt!)
        : '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius.lg),
      child: Container(
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(radius.lg),
          border: Border.all(color: colors.divider, width: spacing.hairline),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PeriodBadge(period: report.timePeriod),
                  SizedBox(height: spacing.xs),
                  Text(
                    formattedDate,
                    style: typography.label.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colors.icon),
          ],
        ),
      ),
    );
  }
}

class _PeriodBadge extends StatelessWidget {
  const _PeriodBadge({required this.period});
  final String? period;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final radius = context.radius;

    final label = period != null ? 'reports.period_$period'.tr() : '';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: BorderRadius.circular(radius.sm),
      ),
      child: Text(
        label,
        style: typography.medicalRecordProgress.copyWith(color: colors.primary),
      ),
    );
  }
}

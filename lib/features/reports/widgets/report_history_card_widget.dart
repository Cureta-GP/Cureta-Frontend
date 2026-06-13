import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import '../data/models/health_report_model.dart';
import 'report_status_badge_widget.dart';

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
            CircleAvatar(
              radius: spacing.xl,
              backgroundColor: colors.accentCyan,
              child: Icon(
                Icons.person,
                color: colors.primary,
                size: spacing.lg,
              ),
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.patientInfo.name,
                          style: typography.medicalRecordDetailBody.copyWith(
                            color: colors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                  SizedBox(width: spacing.md),
                  ReportStatusBadgeWidget(status: report.aiInsights.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

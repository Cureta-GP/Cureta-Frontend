import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/core/theme/theme_extensions.dart';

class ReportStatusBadgeWidget extends StatelessWidget {
  const ReportStatusBadgeWidget({super.key, required this.status});

  final String status; // 'STABLE' or 'ALERT'

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    final isStable = status.toUpperCase() == 'STABLE';
    final badgeColor = isStable ? colors.statusOnline : colors.error;
    final icon = isStable
        ? Icons.check_circle_outline
        : Icons.warning_amber_rounded;
    final labelKey = isStable
        ? 'reports.status_stable'
        : 'reports.status_alert';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(context.radius.full),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: context.spacing.hairline,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: badgeColor, size: spacing.lg),
          SizedBox(width: spacing.xs),
          Text(
            labelKey.tr(),
            style: typography.medicalRecordDetailLabel.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

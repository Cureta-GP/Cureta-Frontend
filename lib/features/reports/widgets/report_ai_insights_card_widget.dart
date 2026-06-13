import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import '../data/models/ai_insights_model.dart';
import 'report_status_badge_widget.dart';

class ReportAiInsightsCardWidget extends StatelessWidget {
  const ReportAiInsightsCardWidget({super.key, required this.insights});

  final AiInsightsModel insights;

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
          Row(
            children: [
              ReportStatusBadgeWidget(status: insights.status),
              const Spacer(),
            ],
          ),
          SizedBox(height: spacing.md),
          ...insights.summary.map((bullet) => _BulletItem(text: bullet)),
          if (insights.correlationWarning.isNotEmpty) ...[
            SizedBox(height: spacing.md),
            _WarningBox(warning: insights.correlationWarning),
          ],
        ],
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  const _BulletItem({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: spacing.xs),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: spacing.sm),
          Expanded(child: Text(text, style: context.typography.body)),
        ],
      ),
    );
  }
}

class _WarningBox extends StatelessWidget {
  const _WarningBox({required this.warning});
  final String warning;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colors.accentOrange,
        borderRadius: BorderRadius.circular(radius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: colors.textPrimary, size: spacing.lg),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Text(
              warning,
              style: context.typography.medicalRecordDetailLabel.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

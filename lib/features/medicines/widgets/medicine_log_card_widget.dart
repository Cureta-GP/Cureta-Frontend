import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';

class MedicineLogCardWidget extends StatelessWidget {
  const MedicineLogCardWidget({
    super.key,
    required this.label,
    required this.timeLabel,
    required this.color,
    this.notes,
  });

  final String label;
  final String timeLabel;
  final Color color;
  final String? notes;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;
    final typography = context.typography;
    final radius = context.radius;
    final hasNotes = notes != null && notes!.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(radius.md),
        border: Border.all(color: colors.divider, width: spacing.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: typography.medicalRecordDetailBody.copyWith(color: color),
          ),
          SizedBox(height: spacing.xs),
          Text(
            timeLabel,
            style: typography.medicalRecordDetailLabel.copyWith(
              color: colors.textSecondary,
            ),
          ),
          if (hasNotes) ...[
            SizedBox(height: spacing.xs),
            Text(
              notes!,
              style: typography.body.copyWith(color: colors.textPrimary),
            ),
          ],
        ],
      ),
    );
  }
}

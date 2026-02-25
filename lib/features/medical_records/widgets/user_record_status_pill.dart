import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class UserRecordStatusPill extends StatelessWidget {
  const UserRecordStatusPill({
    super.key,
    required this.label,
    required this.isOngoing,
  });

  final String label;
  final bool isOngoing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    final bg = isOngoing ? colors.medicalRecordAccentSoft : colors.divider;
    final fg = isOngoing ? colors.primary : colors.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: typography.medicalRecordProgress.copyWith(color: fg),
          ),
          if (isOngoing) ...[
            SizedBox(width: spacing.xs),
            Container(
              width: spacing.xs - 2,
              height: spacing.xs - 2,
              decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
            ),
          ],
        ],
      ),
    );
  }
}

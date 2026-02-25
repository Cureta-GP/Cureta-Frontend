import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class UserRecordsFilterChip extends StatelessWidget {
  const UserRecordsFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius.full),
      child: Container(
        constraints: BoxConstraints(minHeight: spacing.xl + spacing.xs),
        padding: EdgeInsets.symmetric(horizontal: spacing.lg),
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.medicalRecordCard,
          borderRadius: BorderRadius.circular(radius.full),
          border: selected
              ? null
              : Border.all(color: colors.medicalRecordOptionBorder),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: typography.medicalRecordStep.copyWith(
            color: selected ? Colors.white : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

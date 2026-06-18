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
    final radius = context.radius;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius.full),
        child: AnimatedContainer(
          duration: context.durations.fast,
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: context.spacing.sm,
            vertical: context.spacing.md,
          ),
          decoration: BoxDecoration(
            color: selected ? colors.primary : colors.surface,
            borderRadius: BorderRadius.circular(radius.full),
            border: Border.all(
              color: selected ? colors.primary : colors.divider,
            ),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: context.typography.medicalRecordProgress.copyWith(
                color: selected ? colors.background : colors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

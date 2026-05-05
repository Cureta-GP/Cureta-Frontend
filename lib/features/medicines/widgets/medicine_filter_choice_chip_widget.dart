import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class MedicineFilterChoiceChipWidget extends StatelessWidget {
  const MedicineFilterChoiceChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(context.radius.full),
        onTap: onTap,
        child: AnimatedContainer(
          duration: context.durations.fast,
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: context.spacing.md,
            vertical: context.spacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary : colors.surface,
            borderRadius: BorderRadius.circular(context.radius.full),
            border: Border.all(
              color: isSelected ? colors.primary : colors.divider,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: context.typography.medicalRecordProgress.copyWith(
              color: isSelected ? colors.background : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

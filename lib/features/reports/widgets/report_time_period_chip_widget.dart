import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/core/theme/theme_extensions.dart';

class ReportTimePeriodChipWidget extends StatelessWidget {
  const ReportTimePeriodChipWidget({
    super.key,
    required this.labelKey,
    required this.isSelected,
    required this.onTap,
  });

  final String labelKey;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.radius.full),
      child: AnimatedContainer(
        duration: context.durations.normal,
        padding: EdgeInsets.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surface,
          borderRadius: BorderRadius.circular(context.radius.full),
          border: Border.all(
            color: isSelected ? colors.primary : colors.divider,
            width: isSelected ? 2 : spacing.hairline,
          ),
        ),
        child: Text(
          labelKey.tr(),
          style: typography.medicalRecordChoice.copyWith(
            color: isSelected ? colors.background : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

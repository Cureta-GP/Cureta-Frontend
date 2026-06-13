import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/core/theme/theme_extensions.dart';

class ReportSectionHeaderWidget extends StatelessWidget {
  const ReportSectionHeaderWidget({
    super.key,
    required this.titleKey,
    this.icon,
  });

  final String titleKey;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: colors.primary, size: spacing.xl),
              SizedBox(width: spacing.sm),
            ],
            Expanded(
              child: Text(
                titleKey.tr(),
                style: typography.medicalRecordScreenTitle.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.xs),
        Divider(color: colors.divider, thickness: spacing.hairline),
      ],
    );
  }
}

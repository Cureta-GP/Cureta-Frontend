import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class AddRecordUploadSectionHeader extends StatelessWidget {
  const AddRecordUploadSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: spacing.xs,
          runSpacing: spacing.xs,
          children: [
            Text(
              AppLocalizations.addRecordOptional,
              style: typography.medicalRecordOptional.copyWith(
                color: colors.textSecondary,
              ),
            ),
            Text(
              AppLocalizations.addRecordRelatedFilesTitle,
              style: typography.medicalRecordUploadTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.md),
        Text(
          AppLocalizations.addRecordRelatedFilesDescription,
          style: typography.medicalRecordUploadDescription.copyWith(
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

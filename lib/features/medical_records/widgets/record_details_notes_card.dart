import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

/// Displays the "Notes" section with a titled card containing the note body.
class RecordDetailsNotesCard extends StatelessWidget {
  const RecordDetailsNotesCard({super.key, required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.recordDetailsNotesTitle,
          style: typography.medicalRecordScreenTitle.copyWith(
            color: colors.medicalRecordStrongText,
          ),
        ),
        SizedBox(height: spacing.md),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(spacing.xl),
          decoration: BoxDecoration(
            color: colors.medicalRecordCard,
            border: Border.all(
              width: 0.8,
              color: colors.medicalRecordOptionBorder,
            ),
            borderRadius: BorderRadius.circular(radius.xxl),
          ),
          child: Text(
            notes,
            style: typography.medicalRecordDetailBody.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

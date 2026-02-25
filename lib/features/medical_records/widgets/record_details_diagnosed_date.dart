import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

/// Displays the "Diagnosed on" label with a calendar icon and date value.
class RecordDetailsDiagnosedDate extends StatelessWidget {
  const RecordDetailsDiagnosedDate({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.recordDetailsDiagnosedOn,
          style: typography.medicalRecordDetailLabel.copyWith(
            color: colors.medicalRecordMuted,
          ),
        ),
        SizedBox(height: spacing.xs),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 24, color: colors.icon),
            SizedBox(width: spacing.md),
            Expanded(
              child: Text(
                date,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: typography.title.copyWith(color: colors.textPrimary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

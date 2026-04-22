import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Date picker field shown when editing a medical record's diagnosed date.
class RecordDetailsEditableDateField extends StatelessWidget {
  const RecordDetailsEditableDateField({
    super.key,
    required this.selectedDate,
    required this.isBusy,
    required this.onTap,
  });

  final DateTime selectedDate;
  final bool isBusy;
  final VoidCallback onTap;

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
          AppLocalizations.recordDetailsDiagnosedOn,
          style: typography.medicalRecordDetailLabel.copyWith(
            color: colors.textSecondary,
          ),
        ),
        SizedBox(height: spacing.xs),
        InkWell(
          borderRadius: BorderRadius.circular(radius.lg),
          onTap: isBusy ? null : onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.md,
            ),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(radius.lg),
              border: Border.all(
                color: colors.divider,
                width: spacing.hairline,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: colors.icon),
                SizedBox(width: spacing.md),
                Expanded(
                  child: Text(
                    DateFormat('MMM d, yyyy').format(selectedDate),
                    style: typography.title.copyWith(color: colors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

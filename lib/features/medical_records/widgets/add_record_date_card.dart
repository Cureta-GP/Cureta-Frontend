import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class AddRecordDateCard extends StatelessWidget {
  const AddRecordDateCard({
    super.key,
    required this.selectedDate,
    required this.onTap,
    this.hasError = false,
    this.errorText,
  });

  final DateTime? selectedDate;
  final VoidCallback onTap;
  final bool hasError;
  final String? errorText;
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    final dateLabel = selectedDate == null
        ? AppLocalizations.addRecordSelectDate
        : MaterialLocalizations.of(context).formatMediumDate(selectedDate!);
    return Container(
      padding: EdgeInsets.all(spacing.xl),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.accentCyan,
                  borderRadius: BorderRadius.circular(radius.md),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: colors.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: spacing.lg),
              Expanded(
                child: Text(
                  AppLocalizations.addRecordFirstSymptomsQuestion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: typography.surfaceTitle.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.lg),
          InkWell(
            borderRadius: BorderRadius.circular(radius.md),
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.lg,
                vertical: spacing.md,
              ),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(radius.md),
                border: Border.all(
                  color: hasError ? colors.error : colors.divider,
                  width: 1.6,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.event, color: colors.primary, size: 24),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: Text(
                      dateLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: typography.medicalRecordPickerLabel.copyWith(
                        color: selectedDate == null
                            ? colors.textHint
                            : colors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.expand_more,
                    color: colors.textSecondary,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (hasError && errorText != null) ...[
            SizedBox(height: spacing.xs),
            Row(
              children: [
                SizedBox(width: spacing.xs),
                Text(
                  errorText!,
                  style: typography.medicalRecordHelper.copyWith(
                    color: colors.error,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

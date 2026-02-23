import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class DateSelectionCard extends StatelessWidget {
  const DateSelectionCard({
    super.key,
    required this.title,
    required this.hintText,
    required this.selectedDate,
    required this.onTap,
    this.icon = Icons.calendar_today,
    this.pickerIcon = Icons.event,
  });

  final String title;
  final String hintText;
  final DateTime? selectedDate;
  final VoidCallback onTap;
  final IconData icon;
  final IconData pickerIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    final dateLabel = selectedDate == null
        ? hintText
        : MaterialLocalizations.of(context).formatMediumDate(selectedDate!);

    return Container(
      padding: EdgeInsets.all(spacing.xl),
      decoration: BoxDecoration(
        color: colors.medicalRecordCard,
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
                  color: colors.medicalRecordAccentSoft,
                  borderRadius: BorderRadius.circular(radius.md),
                ),
                child: Icon(icon, color: colors.primary, size: 24),
              ),
              SizedBox(width: spacing.lg),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: typography.medicalRecordCardTitle.copyWith(
                    color: colors.medicalRecordStrongText,
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
                color: colors.medicalRecordBackground,
                borderRadius: BorderRadius.circular(radius.md),
                border: Border.all(
                  color: colors.medicalRecordInputBorder,
                  width: 1.6,
                ),
              ),
              child: Row(
                children: [
                  Icon(pickerIcon, color: colors.primary, size: 24),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: Text(
                      dateLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: typography.medicalRecordPickerLabel.copyWith(
                        color: selectedDate == null
                            ? colors.medicalRecordInputHint
                            : colors.medicalRecordStrongText,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.expand_more,
                    color: colors.medicalRecordSecondaryStrong,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

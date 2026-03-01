import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/widgets/add_record_choice_button.dart';
import 'package:flutter/material.dart';

class AddRecordOngoingCard extends StatelessWidget {
  const AddRecordOngoingCard({
    super.key,
    required this.isOngoing,
    required this.onChanged,
  });

  final bool isOngoing;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

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
                child: Icon(Icons.schedule, color: colors.primary, size: 24),
              ),
              SizedBox(width: spacing.lg),
              Expanded(
                child: Text(
                  AppLocalizations.addRecordOngoingQuestion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: typography.surfaceTitle.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.xl),
          Row(
            children: [
              Expanded(
                child: AddRecordChoiceButton(
                  label: AppLocalizations.addRecordYes,
                  selected: isOngoing,
                  onTap: () => onChanged(true),
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: AddRecordChoiceButton(
                  label: AppLocalizations.addRecordNo,
                  selected: !isOngoing,
                  onTap: () => onChanged(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

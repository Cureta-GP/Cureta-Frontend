import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
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
                child: Icon(Icons.schedule, color: colors.primary, size: 24),
              ),
              SizedBox(width: spacing.lg),
              Expanded(
                child: Text(
                  AppLocalizations.addRecordOngoingQuestion,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: typography.medicalRecordCardTitle.copyWith(
                    color: colors.medicalRecordStrongText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.xl),
          Row(
            children: [
              Expanded(
                child: _ChoiceButton(
                  label: AppLocalizations.addRecordYes,
                  selected: isOngoing,
                  onTap: () => onChanged(true),
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: _ChoiceButton(
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

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radius;
    final typography = context.typography;

    return InkWell(
      borderRadius: BorderRadius.circular(radius.md),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.medicalRecordBackground,
          borderRadius: BorderRadius.circular(radius.md),
          border: Border.all(
            color: selected ? colors.primary : colors.medicalRecordOptionBorder,
            width: 1.6,
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: typography.medicalRecordChoice.copyWith(
            color: selected ? Colors.white : colors.medicalRecordStrongText,
          ),
        ),
      ),
    );
  }
}

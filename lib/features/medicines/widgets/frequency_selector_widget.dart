import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import '../data/models/medicine_enums.dart';

class FrequencySelectorWidget extends StatelessWidget {
  const FrequencySelectorWidget({
    super.key,
    required this.selectedFrequency,
    required this.onSelected,
  });

  final Frequency? selectedFrequency;
  final ValueChanged<Frequency> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: Frequency.values.map((frequency) {
        final isSelected = selectedFrequency == frequency;
        return Padding(
          padding: EdgeInsets.only(bottom: context.spacing.md),
          child: InkWell(
            borderRadius: BorderRadius.circular(context.radius.lg),
            onTap: () => onSelected(frequency),
            child: AnimatedContainer(
              duration: context.durations.normal,
              padding: EdgeInsets.all(context.spacing.lg),
              decoration: BoxDecoration(
                color: isSelected
                    ? context.colors.secondary
                    : context.colors.surface,
                borderRadius: BorderRadius.circular(context.radius.lg),
                border: Border.all(
                  color: isSelected
                      ? context.colors.primary
                      : context.colors.divider,
                  width: 1.6,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.colors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(context.radius.full),
                    ),
                  ),
                  SizedBox(width: context.spacing.md),
                  Icon(
                    _getIcon(frequency),
                    color: isSelected
                        ? context.colors.primary
                        : context.colors.textSecondary,
                  ),
                  SizedBox(width: context.spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTitleKey(frequency).tr(),
                          style: context.typography.medicalRecordChoice
                              .copyWith(color: context.colors.textPrimary),
                        ),
                        SizedBox(height: context.spacing.xs),
                        Text(
                          _getSubtitleKey(frequency).tr(),
                          style: context.typography.medicalRecordHelper
                              .copyWith(color: context.colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getIcon(Frequency frequency) {
    return switch (frequency) {
      Frequency.daily => Icons.today,
      Frequency.weekly => Icons.date_range,
      Frequency.asNeeded => Icons.help_outline,
    };
  }

  String _getTitleKey(Frequency frequency) {
    return switch (frequency) {
      Frequency.daily => 'medicines.frequency_daily',
      Frequency.weekly => 'medicines.frequency_weekly',
      Frequency.asNeeded => 'medicines.frequency_as_needed',
    };
  }

  String _getSubtitleKey(Frequency frequency) {
    return switch (frequency) {
      Frequency.daily => 'medicines.frequency_daily_subtitle',
      Frequency.weekly => 'medicines.frequency_weekly_subtitle',
      Frequency.asNeeded => 'medicines.frequency_as_needed_subtitle',
    };
  }
}

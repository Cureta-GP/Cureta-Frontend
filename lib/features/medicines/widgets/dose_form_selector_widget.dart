import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import '../data/models/medicine_enums.dart';

class DoseFormSelectorWidget extends StatelessWidget {
  const DoseFormSelectorWidget({
    super.key,
    required this.selectedForm,
    required this.onSelected,
  });

  final DoseForm? selectedForm;
  final ValueChanged<DoseForm> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.spacing.md,
      runSpacing: context.spacing.md,
      children: DoseForm.values.map((form) {
        final isSelected = selectedForm == form;
        return InkWell(
          borderRadius: BorderRadius.circular(context.radius.lg),
          onTap: () => onSelected(form),
          child: AnimatedContainer(
            duration: context.durations.normal,
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: context.spacing.lg,
              vertical: context.spacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.colors.primary
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIcon(form),
                  size: 20,
                  color: isSelected
                      ? context.colors.background
                      : context.colors.textSecondary,
                ),
                SizedBox(width: context.spacing.sm),
                Text(
                  _getLabelKey(form).tr(),
                  style: context.typography.medicalRecordChoice.copyWith(
                    color: isSelected
                        ? context.colors.background
                        : context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getIcon(DoseForm form) {
    return switch (form) {
      DoseForm.pill => Icons.medication,
      DoseForm.liquid => Icons.water_drop,
      DoseForm.injection => Icons.vaccines,
      DoseForm.drops => Icons.opacity,
      DoseForm.inhaler => Icons.air,
      DoseForm.patch => Icons.healing,
    };
  }

  String _getLabelKey(DoseForm form) {
    return switch (form) {
      DoseForm.pill => 'medicines.dose_form_pill',
      DoseForm.liquid => 'medicines.dose_form_liquid',
      DoseForm.injection => 'medicines.dose_form_injection',
      DoseForm.drops => 'medicines.dose_form_drops',
      DoseForm.inhaler => 'medicines.dose_form_inhaler',
      DoseForm.patch => 'medicines.dose_form_patch',
    };
  }
}

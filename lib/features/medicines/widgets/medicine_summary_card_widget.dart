import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import '../data/models/medicine_model.dart';
import '../data/models/medicine_enums.dart';

class MedicineSummaryCardWidget extends StatelessWidget {
  const MedicineSummaryCardWidget({
    super.key,
    required this.medicine,
    required this.onEditTap,
  });

  final MedicineModel medicine;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.spacing.xl),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(context.radius.xl),
        border: Border.all(color: context.colors.chatQuickActionBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(context, 'medicines.medicine_name_label', medicine.name),
          SizedBox(height: context.spacing.md),
          _buildRow(
            context,
            'medicines.dose_form_label',
            _getDoseFormKey(medicine.doseForm).tr(),
          ),
          SizedBox(height: context.spacing.md),
          _buildRow(
            context,
            'medicines.dose_label',
            '${medicine.doseAmount} ${medicine.doseUnit}'.trim(),
          ),
          SizedBox(height: context.spacing.md),
          _buildRow(
            context,
            'medicines.frequency_label',
            _getFrequencyKey(medicine.frequency).tr(),
          ),
          if (medicine.alarmTimes.isNotEmpty) ...[
            SizedBox(height: context.spacing.md),
            _buildRow(
              context,
              'medicines.alarm_times_label',
              medicine.alarmTimes.join(', '),
            ),
          ],
          if (medicine.notes != null && medicine.notes!.isNotEmpty) ...[
            SizedBox(height: context.spacing.md),
            _buildRow(context, 'medicines.notes_label', medicine.notes!),
          ],
          SizedBox(height: context.spacing.xl),
          OutlinedButton(
            onPressed: onEditTap,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: context.colors.chatQuickActionBorder),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.radius.lg),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing.lg,
                vertical: context.spacing.md,
              ),
            ),
            child: Text(
              'medicines.edit_details'.tr(),
              style: context.typography.medicalRecordDetailLabel.copyWith(
                color: context.colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String labelKey, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            labelKey.tr(),
            style: context.typography.medicalRecordDetailLabel.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.typography.medicalRecordDetailBody.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  String _getDoseFormKey(DoseForm form) {
    return switch (form) {
      DoseForm.pill => 'medicines.dose_form_pill',
      DoseForm.liquid => 'medicines.dose_form_liquid',
      DoseForm.injection => 'medicines.dose_form_injection',
      DoseForm.drops => 'medicines.dose_form_drops',
      DoseForm.inhaler => 'medicines.dose_form_inhaler',
      DoseForm.patch => 'medicines.dose_form_patch',
    };
  }

  String _getFrequencyKey(Frequency frequency) {
    return switch (frequency) {
      Frequency.daily => 'medicines.frequency_daily',
      Frequency.weekly => 'medicines.frequency_weekly',
      Frequency.asNeeded => 'medicines.frequency_as_needed',
    };
  }
}

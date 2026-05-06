import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import '../data/models/medicine_model.dart';
import '../data/models/medicine_enums.dart';
import 'medicine_image_widget.dart';

class MedicineInfoCardWidget extends StatelessWidget {
  const MedicineInfoCardWidget({super.key, required this.medicine});
  final MedicineModel medicine;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;
    final doseText = '${medicine.doseAmount} ${medicine.doseUnit}'.trim();

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius.lg),
        border: Border.all(color: colors.divider, width: spacing.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MedicineImageWidget(
            imagePath: medicine.imagePath,
            size: spacing.xxl * 10,
          ),
          SizedBox(height: spacing.md),
          Text(
            doseText,
            textAlign: TextAlign.center,
            style: typography.surfaceTitle.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            'medicines.dose_label'.tr(),
            style: typography.medicalRecordDetailLabel.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing.md),
          Text(
            _frequencyKey(medicine.frequency).tr(),
            style: typography.medicalRecordDetailBody.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            'medicines.frequency_label'.tr(),
            style: typography.medicalRecordDetailLabel.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _frequencyKey(Frequency frequency) => switch (frequency) {
    Frequency.daily => 'medicines.frequency_daily',
    Frequency.weekly => 'medicines.frequency_weekly',
    Frequency.asNeeded => 'medicines.frequency_as_needed',
  };
}

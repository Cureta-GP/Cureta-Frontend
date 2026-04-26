import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import '../data/models/medicine_model.dart';
import '../data/models/medicine_enums.dart';

class MedicineCardWidget extends StatelessWidget {
  const MedicineCardWidget({
    super.key,
    required this.medicine,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  final MedicineModel medicine;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(medicine.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsetsDirectional.only(end: context.spacing.xl),
        decoration: BoxDecoration(
          color: context.colors.error,
          borderRadius: BorderRadius.circular(context.radius.lg),
        ),
        child: Icon(Icons.delete, color: context.colors.background),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(context.radius.lg),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(context.spacing.lg),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(context.radius.lg),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            medicine.name,
                            style: context.typography.medicalRecordChoice
                                .copyWith(color: context.colors.textPrimary),
                          ),
                        ),
                        if (medicine.syncStatus == SyncStatus.pending)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: context.colors.accentOrange,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: context.spacing.xs),
                    Text(
                      '${medicine.doseAmount} ${medicine.doseUnit} • ${_getFrequencyKey(medicine.frequency).tr()}',
                      style: context.typography.medicalRecordDetailLabel
                          .copyWith(color: context.colors.textSecondary),
                    ),
                    if (medicine.alarmTimes.isNotEmpty) ...[
                      SizedBox(height: context.spacing.sm),
                      Wrap(
                        spacing: context.spacing.xs,
                        children: medicine.alarmTimes.map((time) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.spacing.sm,
                              vertical: context.spacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.secondary,
                              borderRadius: BorderRadius.circular(
                                context.radius.full,
                              ),
                            ),
                            child: Text(
                              time,
                              style: context.typography.medicalRecordProgress
                                  .copyWith(color: context.colors.primary),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              Switch(
                value: medicine.isActive,
                onChanged: onToggle,
                activeTrackColor: context.colors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFrequencyKey(Frequency frequency) {
    return switch (frequency) {
      Frequency.daily => 'medicines.frequency_daily',
      Frequency.weekly => 'medicines.frequency_weekly',
      Frequency.asNeeded => 'medicines.frequency_as_needed',
    };
  }
}

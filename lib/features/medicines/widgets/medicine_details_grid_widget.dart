import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import '../data/models/medicine_model.dart';

class MedicineDetailsGridWidget extends StatelessWidget {
  const MedicineDetailsGridWidget({
    super.key,
    required this.medicine,
    required this.onToggleActive,
  });

  final MedicineModel medicine;
  final ValueChanged<bool> onToggleActive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors,
        spacing = context.spacing,
        radius = context.radius,
        typography = context.typography;
    final notes = medicine.notes?.trim();
    final notesValue = notes != null && notes.isNotEmpty
        ? notes
        : 'medicines.details_notes_empty'.tr();
    Widget infoTile(String label, String value, {bool muted = false}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: typography.medicalRecordDetailLabel.copyWith(
              color: colors.textSecondary,
              fontSize: 14,
            ),
          ),
          SizedBox(height: spacing.sm),
          Text(
            value,
            style: typography.medicalRecordDetailBody.copyWith(
              color: muted ? colors.textHint : colors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      );
    }

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius.lg),
        border: Border.all(color: colors.divider, width: spacing.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: infoTile(
                  'medicines.details_start_date_label'.tr(),
                  _formatDate(context, medicine.startDate),
                ),
              ),
              SizedBox(width: spacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'medicines.details_active_label'.tr(),
                      style: typography.medicalRecordDetailLabel.copyWith(
                        color: colors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: spacing.xs),
                    Switch(
                      value: medicine.isActive,
                      onChanged: onToggleActive,
                      activeThumbColor: colors.background,
                      activeTrackColor: colors.primary,
                      inactiveThumbColor: colors.background,
                      inactiveTrackColor: colors.divider,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.lg),
          infoTile(
            'medicines.details_notes_label'.tr(),
            notesValue,
            muted: notes == null || notes.isEmpty,
          ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(date.toLocal());
  }
}

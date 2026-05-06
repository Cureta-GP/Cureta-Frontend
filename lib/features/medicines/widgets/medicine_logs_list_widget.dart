import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import '../data/models/dose_log_model.dart';
import 'medicine_log_item_widget.dart';

class MedicineLogsListWidget extends StatelessWidget {
  const MedicineLogsListWidget({super.key, required this.logs});

  final List<DoseLogModel> logs;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;
    final radius = context.radius;
    final typography = context.typography;
    final orderedLogs = List<DoseLogModel>.from(logs)
      ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

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
          Text(
            'medicines.details_history_title'.tr(),
            style: typography.medicalRecordPickerLabel.copyWith(
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: spacing.md),
          if (orderedLogs.isEmpty)
            Text(
              'medicines.details_no_logs'.tr(),
              style: typography.body.copyWith(color: colors.textSecondary),
            ),
          for (var i = 0; i < orderedLogs.length; i++)
            MedicineLogItemWidget(
              log: orderedLogs[i],
              isLast: i == orderedLogs.length - 1,
            ),
        ],
      ),
    );
  }
}

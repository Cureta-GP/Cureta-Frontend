import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import '../data/models/dose_log_model.dart';
import '../data/models/medicine_enums.dart';
import 'medicine_log_card_widget.dart';
import 'medicine_log_timeline_widget.dart';

class MedicineLogItemWidget extends StatelessWidget {
  const MedicineLogItemWidget({
    super.key,
    required this.log,
    required this.isLast,
  });
  final DoseLogModel log;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final style = _statusStyle(context, log.status);
    final timeLabel = _formatDateTime(context, log.takenAt ?? log.scheduledAt);

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: isLast ? 0 : spacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MedicineLogTimelineWidget(
            color: style.color,
            icon: style.icon,
            isLast: isLast,
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: MedicineLogCardWidget(
              label: style.label,
              timeLabel: timeLabel,
              color: style.color,
              notes: log.notes?.trim(),
            ),
          ),
        ],
      ),
    );
  }

  ({Color color, IconData icon, String label}) _statusStyle(
    BuildContext context,
    DoseStatus status,
  ) {
    final colors = context.colors;
    return switch (status) {
      DoseStatus.taken => (
        color: colors.success,
        icon: Icons.check_circle,
        label: 'medicines.alarm_taken'.tr(),
      ),
      DoseStatus.missed => (
        color: colors.error,
        icon: Icons.cancel,
        label: 'medicines.alarm_missed'.tr(),
      ),
      DoseStatus.skipped => (
        color: colors.textSecondary,
        icon: Icons.remove_circle_outline,
        label: 'medicines.details_status_skipped'.tr(),
      ),
      DoseStatus.pending => (
        color: colors.icon,
        icon: Icons.schedule,
        label: 'medicines.details_status_pending'.tr(),
      ),
    };
  }

  String _formatDateTime(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).add_jm().format(date.toLocal());
  }
}

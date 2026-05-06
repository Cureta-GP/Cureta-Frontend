import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';

/// "Add alarm time" button — stateless, no rebuild needed.
class AddAlarmTimeButtonWidget extends StatelessWidget {
  const AddAlarmTimeButtonWidget({
    super.key,
    this.onTimePicked,
    this.initialTime,
  });

  final ValueChanged<TimeOfDay>? onTimePicked;
  final TimeOfDay? initialTime;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return TextButton.icon(
      onPressed: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: initialTime ?? TimeOfDay.now(),
        );
        if (picked != null && context.mounted) {
          if (onTimePicked != null) {
            onTimePicked!(picked);
          } else {
            context.read<AddMedicineCubit>().addAlarmTime(picked);
          }
        }
      },
      icon: Icon(Icons.add_alarm, color: colors.primary),
      label: Text(
        'medicines.add_alarm_time'.tr(),
        style: typography.medicalRecordChoice.copyWith(color: colors.primary),
      ),
    );
  }
}

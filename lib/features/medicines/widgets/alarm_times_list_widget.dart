import 'package:cureta/features/medicines/veiw_model/add_medicine_state_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state.dart';
import 'package:cureta/features/medicines/widgets/time_picker_row_widget.dart';

/// List of alarm time rows — rebuilds only when [alarmTimes] changes.
class AlarmTimesListWidget extends StatelessWidget {
  const AlarmTimesListWidget({super.key});

  static String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return BlocSelector<AddMedicineCubit, AddMedicineState, List<TimeOfDay>>(
      selector: (state) => state.formData.alarmTimes,
      builder: (context, times) => Column(
        children: List.generate(times.length, (i) {
          final time = times[i];
          return Padding(
            padding: EdgeInsetsDirectional.only(bottom: spacing.sm),
            child: TimePickerRowWidget(
              time: _fmt(time),
              canRemove: true,
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: time,
                );
                if (picked != null && context.mounted) {
                  context.read<AddMedicineCubit>().removeAlarmTime(i);
                  context.read<AddMedicineCubit>().addAlarmTime(picked);
                }
              },
              onRemove: () =>
                  context.read<AddMedicineCubit>().removeAlarmTime(i),
            ),
          );
        }),
      ),
    );
  }
}

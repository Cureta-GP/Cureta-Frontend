import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state.dart';
import 'package:cureta/features/medicines/widgets/time_picker_row_widget.dart';
import 'package:cureta/shared/widgets/add_record_next_button.dart';
import 'package:cureta/shared/widgets/custom_top_bar.dart';
import 'package:cureta/shared/widgets/step_progress_indicator.dart';

class AddMedicineThirdStepVeiw extends StatelessWidget {
  const AddMedicineThirdStepVeiw({super.key});

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddMedicineCubit, AddMedicineState>(
      listenWhen: (previous, current) =>
          current is AddMedicineValidated && current.stepNumber == 3,
      listener: (context, state) {
        if (state is AddMedicineValidated && state.stepNumber == 3) {
          context.push('/medicines/add/4');
        }
      },
      builder: (context, state) {
        final currentData = _getData(state);
        final colors = context.colors;
        final spacing = context.spacing;
        final typography = context.typography;

        return Scaffold(
          backgroundColor: colors.background,
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.xl,
                spacing.md,
                spacing.xl,
                spacing.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AddRecordNextButton(
                    onPressed: () {
                      context.read<AddMedicineCubit>().validateStep3();
                    },
                  ),
                  SizedBox(height: spacing.md),
                  TextButton(
                    onPressed: () {
                      context.read<AddMedicineCubit>().skipStep3();
                    },
                    child: Text(
                      'medicines.skip_for_now'.tr(),
                      style: typography.medicalRecordSkip.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                CustomTopBar(onBack: () => context.pop()),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: spacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StepProgressIndicator(
                          stepLabel: 'medicines.step_3_of_5'.tr(),
                          progressLabel: 'medicines.step_3_progress'.tr(),
                          progress: 0.6,
                        ),
                        SizedBox(height: spacing.xxl),
                        Text(
                          'medicines.step_3_question'.tr(),
                          style: typography.medicalRecordQuestion.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: spacing.xl),
                        Text(
                          'medicines.alarm_times_label'.tr(),
                          style: typography.medicalRecordDetailLabel.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        SizedBox(height: spacing.md),
                        ...List.generate(currentData.alarmTimes.length, (index) {
                          final time = currentData.alarmTimes[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: spacing.sm),
                            child: TimePickerRowWidget(
                              time: _formatTime(time),
                              canRemove: true,
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: time,
                                );
                                if (picked != null && context.mounted) {
                                  context
                                      .read<AddMedicineCubit>()
                                      .removeAlarmTime(index);
                                  context
                                      .read<AddMedicineCubit>()
                                      .addAlarmTime(picked);
                                }
                              },
                              onRemove: () {
                                context
                                    .read<AddMedicineCubit>()
                                    .removeAlarmTime(index);
                              },
                            ),
                          );
                        }),
                        TextButton.icon(
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null && context.mounted) {
                              context
                                  .read<AddMedicineCubit>()
                                  .addAlarmTime(picked);
                            }
                          },
                          icon: Icon(Icons.add_alarm, color: colors.primary),
                          label: Text(
                            'medicines.add_alarm_time'.tr(),
                            style: typography.medicalRecordChoice.copyWith(
                              color: colors.primary,
                            ),
                          ),
                        ),
                        SizedBox(height: spacing.xl),
                        Text(
                          'medicines.notes_label'.tr(),
                          style: typography.medicalRecordDetailLabel.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        SizedBox(height: spacing.md),
                        TextField(
                          maxLines: 4,
                          onChanged: (v) {
                            context.read<AddMedicineCubit>().updateNotes(v);
                          },
                          decoration: InputDecoration(
                            hintText: 'medicines.notes_hint'.tr(),
                            suffixIcon: Icon(
                              Icons.edit_note,
                              color: colors.primary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                context.radius.md,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                context.radius.md,
                              ),
                              borderSide: BorderSide(color: colors.primary),
                            ),
                          ),
                        ),
                        SizedBox(height: spacing.xl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  AddMedicineStepUpdated _getData(AddMedicineState state) {
    return switch (state) {
      AddMedicineInitial() => AddMedicineStepUpdated(startDate: DateTime.now()),
      AddMedicineStepUpdated data => data,
      AddMedicineValidated data => data.data,
      AddMedicineScanRequested data => data.data,
      AddMedicineLoading data => data.data,
      AddMedicineFailure data => data.data,
      AddMedicineSuccess() => AddMedicineStepUpdated(startDate: DateTime.now()),
    };
  }
}

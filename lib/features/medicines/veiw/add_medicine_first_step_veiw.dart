import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state.dart';
import 'package:cureta/shared/widgets/add_record_next_button.dart';
import 'package:cureta/shared/widgets/custom_top_bar.dart';
import 'package:cureta/shared/widgets/step_progress_indicator.dart';

class AddMedicineFirstStepVeiw extends StatelessWidget {
  const AddMedicineFirstStepVeiw({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddMedicineCubit, AddMedicineState>(
      listener: (context, state) {
        if (state is AddMedicineValidated && state.stepNumber == 1) {
          context.push('/medicines/add/2');
        }
      },
      builder: (context, state) {
        final currentData = _getData(state);
        final colors = context.colors;
        final spacing = context.spacing;
        final typography = context.typography;

        return Scaffold(
          backgroundColor: colors.chatBackground,
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
                      context.read<AddMedicineCubit>().validateStep1();
                    },
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
                          stepLabel: 'medicines.step_1_of_5'.tr(),
                          progressLabel: 'medicines.step_1_progress'.tr(),
                          progress: 0.2,
                        ),
                        SizedBox(height: spacing.xxl),
                        Text(
                          'medicines.step_1_question'.tr(),
                          style: typography.medicalRecordQuestion.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: spacing.sm),
                        Text(
                          'medicines.step_1_subtitle'.tr(),
                          style: typography.medicalRecordPickerLabel.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        SizedBox(height: spacing.xl),
                        TextField(
                          onChanged: (v) {
                            context.read<AddMedicineCubit>().updateMedicineName(
                              v,
                            );
                          },
                          decoration: InputDecoration(
                            hintText: 'medicines.medicine_name_hint'.tr(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.photo_camera,
                                color: colors.primary,
                              ),
                              onPressed: () {
                                context.read<AddMedicineCubit>().requestScan();
                              },
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
                        if (currentData.validationErrors['medicineName'] !=
                            null) ...[
                          SizedBox(height: spacing.sm),
                          AnimatedSwitcher(
                            duration: context.durations.fast,
                            child: Text(
                              currentData.validationErrors['medicineName']!
                                  .tr(),
                              key: ValueKey(
                                currentData.validationErrors['medicineName'],
                              ),
                              style: typography.label.copyWith(
                                color: colors.error,
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: spacing.lg),
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: colors.textHint,
                              size: 16,
                            ),
                            SizedBox(width: spacing.sm),
                            Text(
                              'medicines.step_1_info_hint'.tr(),
                              style: typography.medicalRecordHelper.copyWith(
                                color: colors.textHint,
                              ),
                            ),
                          ],
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

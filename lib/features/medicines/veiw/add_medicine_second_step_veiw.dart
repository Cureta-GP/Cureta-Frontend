import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state_mapper.dart';
import 'package:cureta/features/medicines/widgets/dose_form_selector_widget.dart';
import 'package:cureta/features/medicines/widgets/frequency_selector_widget.dart';
import 'package:cureta/shared/widgets/add_record_next_button.dart';
import 'package:cureta/shared/widgets/custom_top_bar.dart';
import 'package:cureta/shared/widgets/step_progress_indicator.dart';

class AddMedicineSecondStepVeiw extends StatelessWidget {
  const AddMedicineSecondStepVeiw({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddMedicineCubit, AddMedicineState>(
      listener: (context, state) {
        if (state is AddMedicineValidated && state.stepNumber == 2) {
          context.push('/medicines/add/3');
        }
      },
      builder: (context, state) {
        final currentData = state.formData;
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
                      context.read<AddMedicineCubit>().validateStep2();
                    },
                  ),
                  SizedBox(height: spacing.md),
                  TextButton(
                    onPressed: () {
                      context.read<AddMedicineCubit>().skipStep2();
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
                          stepLabel: 'medicines.step_2_of_5'.tr(),
                          progressLabel: 'medicines.step_2_progress'.tr(),
                          progress: 0.4,
                        ),
                        SizedBox(height: spacing.xxl),
                        Text(
                          'medicines.step_2_question'.tr(),
                          style: typography.medicalRecordQuestion.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: spacing.xl),
                        Text(
                          'medicines.dose_form_label'.tr(),
                          style: typography.medicalRecordDetailLabel.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        SizedBox(height: spacing.md),
                        DoseFormSelectorWidget(
                          selectedForm: currentData.doseForm,
                          onSelected: (form) {
                            context.read<AddMedicineCubit>().updateDoseForm(
                              form,
                            );
                          },
                        ),
                        if (currentData.validationErrors['doseForm'] !=
                            null) ...[
                          SizedBox(height: spacing.sm),
                          Text(
                            currentData.validationErrors['doseForm']!.tr(),
                            style: typography.label.copyWith(
                              color: colors.error,
                            ),
                          ),
                        ],
                        SizedBox(height: spacing.xl),
                        Text(
                          'medicines.frequency_label'.tr(),
                          style: typography.medicalRecordDetailLabel.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        SizedBox(height: spacing.md),
                        FrequencySelectorWidget(
                          selectedFrequency: currentData.frequency,
                          onSelected: (freq) {
                            context.read<AddMedicineCubit>().updateFrequency(
                              freq,
                            );
                          },
                        ),
                        if (currentData.validationErrors['frequency'] !=
                            null) ...[
                          SizedBox(height: spacing.sm),
                          Text(
                            currentData.validationErrors['frequency']!.tr(),
                            style: typography.label.copyWith(
                              color: colors.error,
                            ),
                          ),
                        ],
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
}

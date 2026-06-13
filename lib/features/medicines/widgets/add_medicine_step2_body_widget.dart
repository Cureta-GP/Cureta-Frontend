import 'package:cureta/features/medicines/veiw_model/add_medicine_state_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/features/medicines/data/models/medicine_enums.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state.dart';
import 'package:cureta/features/medicines/widgets/dose_form_selector_widget.dart';
import 'package:cureta/features/medicines/widgets/frequency_selector_widget.dart';
import 'package:cureta/features/medicines/widgets/medicine_validation_error_widget.dart';
import 'package:cureta/shared/widgets/add_record_next_button.dart';
import 'package:cureta/shared/widgets/custom_top_bar.dart';
import 'package:cureta/shared/widgets/step_progress_indicator.dart';

/// Scaffold body for Step 2 of the add-medicine flow.
class AddMedicineStep2BodyWidget extends StatelessWidget {
  const AddMedicineStep2BodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Scaffold(
      backgroundColor: colors.chatBackground,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            spacing.xl, spacing.md, spacing.xl, spacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AddRecordNextButton(
                onPressed: () =>
                    context.read<AddMedicineCubit>().validateStep2(),
              ),
              SizedBox(height: spacing.md),
              TextButton(
                onPressed: () => context.read<AddMedicineCubit>().skipStep2(),
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
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: spacing.xl,
                ),
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
                    BlocSelector<AddMedicineCubit, AddMedicineState, DoseForm?>(
                      selector: (state) => state.formData.doseForm,
                      builder: (context, form) => DoseFormSelectorWidget(
                        selectedForm: form,
                        onSelected: (f) =>
                            context.read<AddMedicineCubit>().updateDoseForm(f),
                      ),
                    ),
                    const MedicineValidationErrorWidget(
                      fieldKey: 'doseForm',
                      useTrExtension: true,
                    ),
                    SizedBox(height: spacing.xl),
                    Text(
                      'medicines.frequency_label'.tr(),
                      style: typography.medicalRecordDetailLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: spacing.md),
                    BlocSelector<AddMedicineCubit, AddMedicineState,
                        Frequency?>(
                      selector: (state) => state.formData.frequency,
                      builder: (context, freq) => FrequencySelectorWidget(
                        selectedFrequency: freq,
                        onSelected: (f) =>
                            context.read<AddMedicineCubit>().updateFrequency(f),
                      ),
                    ),
                    const MedicineValidationErrorWidget(
                      fieldKey: 'frequency',
                      useTrExtension: true,
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
  }
}

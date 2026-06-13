import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/features/medicines/widgets/alarm_times_list_widget.dart';
import 'package:cureta/features/medicines/widgets/add_alarm_time_button_widget.dart';
import 'package:cureta/features/medicines/widgets/medicin_notes_widget.dart';
import 'package:cureta/shared/widgets/add_record_next_button.dart';
import 'package:cureta/shared/widgets/custom_top_bar.dart';
import 'package:cureta/shared/widgets/step_progress_indicator.dart';

/// Scaffold body for Step 3 of the add-medicine flow (alarm times + notes).
class AddMedicineStep3BodyWidget extends StatelessWidget {
  const AddMedicineStep3BodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Scaffold(
      backgroundColor: colors.background,
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
                    context.read<AddMedicineCubit>().validateStep3(),
              ),
              SizedBox(height: spacing.md),
              TextButton(
                onPressed: () => context.read<AddMedicineCubit>().skipStep3(),
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
                    const AlarmTimesListWidget(),
                    const AddAlarmTimeButtonWidget(),
                    SizedBox(height: spacing.xl),
                    Text(
                      'medicines.notes_label'.tr(),
                      style: typography.medicalRecordDetailLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: spacing.md),
                    const MedicineNotesFieldWidget(),
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


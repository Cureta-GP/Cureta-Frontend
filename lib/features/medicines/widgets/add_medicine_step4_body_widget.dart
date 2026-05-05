import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state_mapper.dart';
import 'package:cureta/features/medicines/data/models/medicine_model.dart';
import 'package:cureta/features/medicines/data/models/medicine_enums.dart';
import 'package:cureta/features/medicines/widgets/medicine_summary_card_widget.dart';
import 'package:cureta/shared/widgets/add_record_next_button.dart';
import 'package:cureta/shared/widgets/custom_screen_header.dart';
import 'package:cureta/shared/widgets/step_progress_indicator.dart';

/// Scaffold body for Step 4 (review & save).
/// [BlocSelector] limits rebuilds to [isLoading] changes only.
class AddMedicineStep4BodyWidget extends StatelessWidget {
  const AddMedicineStep4BodyWidget({super.key});
  static MedicineModel buildPreview(AddMedicineStepUpdated data) {
    final now = DateTime.now();
    return MedicineModel(
      id: '',
      name: data.medicineName,
      doseForm: data.doseForm ?? DoseForm.pill,
      doseAmount: data.doseAmount,
      doseUnit: data.doseUnit,
      frequency: data.frequency ?? Frequency.daily,
      alarmTimes: data.alarmTimes.map((t) {
        final h = t.hour.toString().padLeft(2, '0');
        final m = t.minute.toString().padLeft(2, '0');
        return '$h:$m';
      }).toList(),
      startDate: data.startDate,
      notes: data.notes.isEmpty ? null : data.notes,
      isActive: true,
      syncStatus: SyncStatus.pending,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return BlocSelector<AddMedicineCubit, AddMedicineState, bool>(
      selector: (state) => state is AddMedicineLoading,
      builder: (context, isLoading) {
        final data = context.read<AddMedicineCubit>().state.formData;
        return AbsorbPointer(
          absorbing: isLoading,
          child: Scaffold(
            backgroundColor: colors.background,
            body: SafeArea(
              child: Column(
                children: [
                  CustomScreenHeader(
                    title: 'medicines.add_medicine'.tr(),
                    onBack: () => context.pop(),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: spacing.lg,
                    ),
                    child: StepProgressIndicator(
                      stepLabel: 'medicines.step_4_of_5'.tr(),
                      progressLabel: 'medicines.step_4_progress'.tr(),
                      progress: 0.8,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsetsDirectional.all(spacing.lg),
                      child: Column(
                        children: [
                          SizedBox(height: spacing.lg),
                          Text(
                            'medicines.step4_question'.tr(),
                            textAlign: TextAlign.center,
                            style:
                                typography.medicalRecordScreenTitle.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: spacing.xl),
                          MedicineSummaryCardWidget(
                            medicine: buildPreview(data),
                            onEditTap: () => context.go('/medicines/add/1'),
                          ),
                          SizedBox(height: spacing.md),
                          Text(
                            'medicines.step4_helper'.tr(),
                            textAlign: TextAlign.center,
                            style: typography.body.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.all(spacing.lg),
                    child: AddRecordNextButton(
                      label: 'medicines.save_reminder'.tr(),
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () => context
                              .read<AddMedicineCubit>()
                              .submitMedicine(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

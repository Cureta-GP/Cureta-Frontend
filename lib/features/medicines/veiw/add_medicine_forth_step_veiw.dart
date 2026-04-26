import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state.dart';
import 'package:cureta/features/medicines/data/models/medicine_model.dart';
import 'package:cureta/features/medicines/data/models/medicine_enums.dart';
import 'package:cureta/features/medicines/widgets/medicine_summary_card_widget.dart';
import 'package:cureta/shared/widgets/add_record_next_button.dart';
import 'package:cureta/shared/widgets/custom_screen_header.dart';
import 'package:cureta/shared/widgets/step_progress_indicator.dart';

class AddMedicineFourthStepVeiw extends StatelessWidget {
  const AddMedicineFourthStepVeiw({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddMedicineCubit, AddMedicineState>(
      listenWhen: (previous, current) =>
          current is AddMedicineSuccess || current is AddMedicineFailure,
      listener: (context, state) {
        if (state is AddMedicineSuccess) {
          context.push('/medicines/add/5');
        }
        if (state is AddMedicineFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage.tr()),
              backgroundColor: context.colors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AddMedicineLoading;
        final currentData = _getData(state);
        final medicineModel = _buildMedicineModel(currentData);
        final colors = context.colors;
        final spacing = context.spacing;
        final typography = context.typography;

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
                    padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                    child: StepProgressIndicator(
                      stepLabel: 'medicines.step_4_of_5'.tr(),
                      progressLabel: 'medicines.step_4_progress'.tr(),
                      progress: 0.8,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(spacing.lg),
                      child: Column(
                        children: [
                          SizedBox(height: spacing.lg),
                          Text(
                            'medicines.step4_question'.tr(),
                            textAlign: TextAlign.center,
                            style: typography.medicalRecordScreenTitle.copyWith(
                              color: colors.textPrimary,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: spacing.xl),
                          MedicineSummaryCardWidget(
                            medicine: medicineModel,
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
                    padding: EdgeInsets.all(spacing.lg),
                    child: AddRecordNextButton(
                      label: 'medicines.save_reminder'.tr(),
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () => context.read<AddMedicineCubit>().submitMedicine(),
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

  MedicineModel _buildMedicineModel(AddMedicineStepUpdated data) {
    final now = DateTime.now();
    return MedicineModel(
      id: '',
      name: data.medicineName,
      doseForm: data.doseForm ?? DoseForm.pill,
      doseAmount: data.doseAmount.isEmpty ? '' : data.doseAmount,
      doseUnit: data.doseUnit,
      frequency: data.frequency ?? Frequency.daily,
      alarmTimes: data.alarmTimes.map((t) {
        final hour = t.hour.toString().padLeft(2, '0');
        final minute = t.minute.toString().padLeft(2, '0');
        return '$hour:$minute';
      }).toList(),
      startDate: data.startDate,
      notes: data.notes.isEmpty ? null : data.notes,
      isActive: true,
      syncStatus: SyncStatus.pending,
      remoteId: null,
      createdAt: now,
      updatedAt: now,
    );
  }
}

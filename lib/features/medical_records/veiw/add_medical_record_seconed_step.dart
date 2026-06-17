import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_form_cubit.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_two_body.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_two_bottom_bar.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddMedicalRecordSeconedStep extends StatelessWidget {
  const AddMedicalRecordSeconedStep({
    super.key,
    this.onBack,
    this.onNext,
    this.onSkip,
  });

  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final void Function(DateTime? firstSymptomsDate, bool isOngoing)? onNext;

  Future<void> _pickDate(BuildContext context, DateTime? currentDate) async {
    final now = DateTime.now();
    final initialDate = currentDate ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null) {
      if (!context.mounted) return;
      context.read<AddRecordFormCubit>().setRecordDate(picked);
    }
  }

  void _handleNext(BuildContext context, DateTime? date, bool isOngoing) {
    // Date is required
    if (date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.addRecordErrorDateRequired)),
      );
      return;
    }

    onNext?.call(date, isOngoing);
    GoRouter.of(context).pushNamed(AppRoutes.medicalRecords_step_three);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: BlocBuilder<AddRecordFormCubit, AddRecordFormState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: AddRecordStepTwoBody(
                    onBack: onBack,
                    selectedDate: state.recordDate,
                    isOngoing: state.isOngoing,
                    onPickDate: () => _pickDate(context, state.recordDate),
                    onOngoingChanged: (value) {
                      context.read<AddRecordFormCubit>().setIsOngoing(value);
                    },
                  ),
                ),
                AddRecordStepTwoBottomBar(
                  onNext: () =>
                      _handleNext(context, state.recordDate, state.isOngoing),
                  onSkip: onSkip,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

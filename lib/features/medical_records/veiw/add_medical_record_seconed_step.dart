import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_form_cubit.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_two_body.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_two_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddMedicalRecordSeconedStep extends StatefulWidget {
  const AddMedicalRecordSeconedStep({
    super.key,
    this.onBack,
    this.onNext,
    this.onSkip,
  });

  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final void Function(DateTime? firstSymptomsDate, bool isOngoing)? onNext;

  @override
  State<AddMedicalRecordSeconedStep> createState() =>
      _AddMedicalRecordSeconedStepState();
}

class _AddMedicalRecordSeconedStepState
    extends State<AddMedicalRecordSeconedStep> {
  bool _showDateError = false;

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
      // Clear the error once the user picks a date
      setState(() => _showDateError = false);
    }
  }

  void _handleNext(BuildContext context, DateTime? date, bool isOngoing) {
    // Date is required — show inline error instead of snackbar
    if (date == null) {
      setState(() => _showDateError = true);
      return;
    }
    setState(() => _showDateError = false);

    FocusManager.instance.primaryFocus?.unfocus();

    widget.onNext?.call(date, isOngoing);
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
                    onBack: widget.onBack,
                    selectedDate: state.recordDate,
                    isOngoing: state.isOngoing,
                    onPickDate: () => _pickDate(context, state.recordDate),
                    onOngoingChanged: (value) {
                      context.read<AddRecordFormCubit>().setIsOngoing(value);
                    },
                    showDateError: _showDateError,
                    dateErrorText: _showDateError
                        ? AppLocalizations.addRecordErrorDateRequired
                        : null,
                  ),
                ),
                AddRecordStepTwoBottomBar(
                  onNext: () =>
                      _handleNext(context, state.recordDate, state.isOngoing),
                  onSkip: widget.onSkip,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
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
  DateTime? _firstSymptomsDate;
  bool _isOngoing = true;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initialDate = _firstSymptomsDate ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _firstSymptomsDate = picked;
      });
    }
  }

  void _handleNext() {
    // Date is required
    if (_firstSymptomsDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a date')));
      return;
    }

    // Persist to shared cubit
    context.read<AddRecordFormCubit>().setRecordDate(_firstSymptomsDate!);

    widget.onNext?.call(_firstSymptomsDate, _isOngoing);
    GoRouter.of(context).pushNamed(AppRoutes.medicalRecords_step_three);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AddRecordStepTwoBody(
                onBack: widget.onBack,
                selectedDate: _firstSymptomsDate,
                isOngoing: _isOngoing,
                onPickDate: _pickDate,
                onOngoingChanged: (value) {
                  setState(() {
                    _isOngoing = value;
                  });
                },
              ),
            ),
            AddRecordStepTwoBottomBar(
              onNext: _handleNext,
              onSkip: widget.onSkip,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_two_body.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_two_bottom_bar.dart';
import 'package:flutter/material.dart';

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
    widget.onNext?.call(_firstSymptomsDate, _isOngoing);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.medicalRecordBackground,
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

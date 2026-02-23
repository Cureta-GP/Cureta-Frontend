import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_four_body.dart';
import 'package:flutter/material.dart';

class AddRecordForthStep extends StatelessWidget {
  const AddRecordForthStep({
    super.key,
    this.onBack,
    this.onContinue,
    this.onSkip,
    this.onPrescriptionTap,
    this.onLabTestTap,
    this.onScanTap,
  });

  final VoidCallback? onBack;
  final VoidCallback? onContinue;
  final VoidCallback? onSkip;
  final VoidCallback? onPrescriptionTap;
  final VoidCallback? onLabTestTap;
  final VoidCallback? onScanTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.medicalRecordBackground,
      body: SafeArea(
        child: AddRecordStepFourBody(
          onBack: onBack,
          onContinue: onContinue,
          onSkip: onSkip,
          onPrescriptionTap: onPrescriptionTap,
          onLabTestTap: onLabTestTap,
          onScanTap: onScanTap,
        ),
      ),
    );
  }
}

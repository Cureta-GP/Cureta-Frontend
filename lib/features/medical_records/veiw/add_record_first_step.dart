import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/widgets/add_record_condition_section.dart';
import 'package:cureta/features/medical_records/widgets/add_record_next_button.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_progress.dart';
import 'package:cureta/features/medical_records/widgets/add_record_top_bar.dart';
import 'package:flutter/material.dart';

class AddRecordFirstStep extends StatefulWidget {
  const AddRecordFirstStep({
    super.key,
    this.onBack,
    this.onCancel,
    this.onNext,
  });

  final VoidCallback? onBack;
  final VoidCallback? onCancel;
  final ValueChanged<String>? onNext;

  @override
  State<AddRecordFirstStep> createState() => _AddRecordFirstStepState();
}

class _AddRecordFirstStepState extends State<AddRecordFirstStep> {
  final TextEditingController _conditionController = TextEditingController();

  @override
  void dispose() {
    _conditionController.dispose();
    super.dispose();
  }

  void _handleNext() {
    widget.onNext?.call(_conditionController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.medicalRecordBackground,
      body: SafeArea(
        child: Column(
          children: [
            AddRecordTopBar(onBack: widget.onBack, onCancel: widget.onCancel),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AddRecordStepProgress(progress: 0.2),
                    SizedBox(height: spacing.xxl),
                    AddRecordConditionSection(controller: _conditionController),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(bottom: spacing.lg),
                      child: AddRecordNextButton(onPressed: _handleNext),
                    ),
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

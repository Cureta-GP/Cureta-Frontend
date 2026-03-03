import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_two_actions.dart';
import 'package:flutter/material.dart';

class AddRecordStepTwoBottomBar extends StatelessWidget {
  const AddRecordStepTwoBottomBar({
    super.key,
    this.onNext,
    this.onSkip,
    this.nextLabel,
    this.isLoading = false,
  });

  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final String? nextLabel;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final effectiveOnNext = onNext ?? () {};
    final effectiveOnSkip = onSkip ?? () {};

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.md,
        spacing.lg,
        spacing.lg,
      ),
      child: AddRecordStepTwoActions(
        onNext: effectiveOnNext,
        onSkip: effectiveOnSkip,
        nextLabel: nextLabel,
        isLoading: isLoading,
      ),
    );
  }
}

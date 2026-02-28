import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/shared/widgets/add_record_next_button.dart';
import 'package:flutter/material.dart';

class AddRecordStepTwoActions extends StatelessWidget {
  const AddRecordStepTwoActions({
    super.key,
    this.onNext,
    this.onSkip,
    this.nextLabel,
  });
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final String? nextLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AddRecordNextButton(
          onPressed: onNext,
          label: nextLabel ?? AppLocalizations.addRecordNextStep,
        ),
        SizedBox(height: spacing.md),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: spacing.xs),
              minimumSize: const Size(0, 40),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              AppLocalizations.addRecordSkipForNow,
              style: typography.medicalRecordSkip.copyWith(
                color: colors.medicalRecordSecondaryStrong,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

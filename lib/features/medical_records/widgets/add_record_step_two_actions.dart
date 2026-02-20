import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class AddRecordStepTwoActions extends StatelessWidget {
  const AddRecordStepTwoActions({super.key, this.onNext, this.onSkip});

  final VoidCallback? onNext;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius.md),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.addRecordNextStep,
                  style: typography.medicalRecordButton.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: spacing.xs),
                Icon(
                  isRtl ? Icons.arrow_back : Icons.arrow_forward,
                  color: Colors.white,
                ),
              ],
            ),
          ),
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

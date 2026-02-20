import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class AddRecordStepProgress extends StatelessWidget {
  const AddRecordStepProgress({super.key, this.progress = 0.2});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.addRecordStepLabel,
              style: typography.medicalRecordStep.copyWith(
                color: colors.primary,
              ),
            ),
            Text(
              AppLocalizations.addRecordProgressLabel,
              style: typography.medicalRecordProgress.copyWith(
                color: colors.medicalRecordProgressText,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(context.radius.full),
          child: SizedBox(
            height: spacing.xs,
            child: LinearProgressIndicator(
              value: progress,
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
              backgroundColor: colors.medicalRecordProgressTrack,
            ),
          ),
        ),
      ],
    );
  }
}

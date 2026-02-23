import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class AddRecordStepProgress extends StatelessWidget {
  const AddRecordStepProgress({
    super.key,
    required this.stepLabel,
    required this.progressLabel,
    required this.progress,
  });

  final String stepLabel;
  final String progressLabel;
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
          children: [
            Expanded(
              child: Text(
                stepLabel,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: typography.medicalRecordStep.copyWith(
                  color: colors.primary,
                ),
              ),
            ),
            SizedBox(width: spacing.sm),
            Text(
              progressLabel,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
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

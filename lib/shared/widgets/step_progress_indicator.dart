import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class StepProgressIndicator extends StatelessWidget {
  const StepProgressIndicator({
    super.key,
    required this.stepLabel,
    required this.progressLabel,
    required this.progress,
    this.activeColor,
    this.trackColor,
    this.progressTextStyle,
    this.stepTextStyle,
  });

  final String stepLabel;
  final String progressLabel;
  final double progress;
  final Color? activeColor;
  final Color? trackColor;
  final TextStyle? progressTextStyle;
  final TextStyle? stepTextStyle;

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
                style:
                    stepTextStyle ??
                    typography.medicalRecordStep.copyWith(
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
              style:
                  progressTextStyle ??
                  typography.medicalRecordProgress.copyWith(
                    color: colors.textSecondary,
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
              valueColor: AlwaysStoppedAnimation<Color>(
                activeColor ?? colors.primary,
              ),
              backgroundColor: trackColor ?? colors.divider,
            ),
          ),
        ),
      ],
    );
  }
}

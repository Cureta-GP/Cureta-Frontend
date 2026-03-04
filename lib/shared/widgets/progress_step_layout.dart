import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/shared/widgets/add_record_next_button.dart';
import 'package:cureta/shared/widgets/custom_screen_header.dart';
import 'package:cureta/shared/widgets/step_progress_indicator.dart';
import 'package:flutter/material.dart';

class ProgressStepLayout extends StatelessWidget {
  final String appBarTitle;
  final String title;
  final String? subtitle;
  final double progress;
  final String stepLabel;
  final String progressLabel;
  final Widget child;
  final String buttonLabel;
  final VoidCallback onNext;
  final VoidCallback? onSkip;
  final VoidCallback? onBack;

  const ProgressStepLayout({
    super.key,
    required this.appBarTitle,
    required this.title,
    required this.progress,
    required this.stepLabel,
    required this.progressLabel,
    required this.child,
    required this.onNext,
    this.subtitle,
    this.buttonLabel = "Next Step",
    this.onSkip,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomScreenHeader(
              title: appBarTitle,
              onBack: onBack,
              onAction: onSkip,
              actionLabel: onSkip != null ? "Skip" : null,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.lg),
              child: StepProgressIndicator(
                stepLabel: stepLabel,
                progressLabel: progressLabel,
                progress: progress,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(spacing.lg),
                child: Column(
                  children: [
                    SizedBox(height: spacing.lg),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: typography.medicalRecordScreenTitle.copyWith(
                        color: colors.textPrimary,
                        fontSize: 24,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: typography.body.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                    child,
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                children: [
                  AddRecordNextButton(label: buttonLabel, onPressed: onNext),
                  if (onSkip != null)
                    TextButton(
                      onPressed: onSkip,
                      child: Text(
                        "Skip for now",
                        style: typography.body.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

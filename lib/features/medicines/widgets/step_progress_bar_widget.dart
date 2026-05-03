import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';

class StepProgressBarWidget extends StatelessWidget {
  const StepProgressBarWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isCompleted = index < currentStep - 1;
        final isActive = index == currentStep - 1;

        return Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              end: index < totalSteps - 1 ? context.spacing.xs : 0,
            ),
            child: AnimatedContainer(
              duration: context.durations.normal,
              height: context.spacing.xs,
              decoration: BoxDecoration(
                color: isCompleted || isActive
                    ? context.colors.primary
                    : context.colors.divider,
                borderRadius: BorderRadius.circular(context.radius.full),
              ),
            ),
          ),
        );
      }),
    );
  }
}

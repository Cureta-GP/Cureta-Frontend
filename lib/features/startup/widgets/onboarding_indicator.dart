import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class OnboardingIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const OnboardingIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final radius = context.radius;
    final colors = context.colors;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          itemCount,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: EdgeInsets.symmetric(
              horizontal: spacing.xs / 2,
            ),
            width: currentIndex == index ? spacing.lg : spacing.xs,
            height: spacing.xs,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius.sm),
              color: currentIndex == index ? colors.primary : colors.divider,
            ),
          ),
        ),
      ),
    );
  }
}

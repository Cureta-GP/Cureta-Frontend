import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/startup/model/onboarding_model.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel screen;

  const OnboardingPage({
    super.key,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    final styles = context.typography;
    final spacing = context.spacing;
    final radius = context.radius;

    return LayoutBuilder(
      builder: (context, constraints) {
        final imageHeight = constraints.maxHeight * 0.35;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.xxl),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(radius.xl),
                      child: Image.asset(
                        screen.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: spacing.xxl),
                  Text(
                    screen.title,
                    textAlign: TextAlign.center,
                    style: styles.title,
                  ),
                  SizedBox(height: spacing.md),
                  Text(
                    screen.description,
                    textAlign: TextAlign.center,
                    style: styles.body,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

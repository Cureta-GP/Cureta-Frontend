import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingNextButton extends StatelessWidget {
  final int currentIndex;
  final int totalScreens;
  final PageController pageController;

  const OnboardingNextButton({
    super.key,
    required this.currentIndex,
    required this.totalScreens,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;

    return Container(
      width: spacing.xxl + spacing.xl,
      height: spacing.xxl + spacing.xl,
      decoration: BoxDecoration(
        color: colors.primary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          AppLocalizations.isRTL(context)
              ? Icons.arrow_forward
              : Icons.arrow_back,
          color: Theme.of(context).colorScheme.onPrimary,
          size: spacing.xl,
        ),
        onPressed: () {
          if (currentIndex == totalScreens - 1) {
            GoRouter.of(context).go(AppRoutes.signup);
          } else {
            pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
      ),
    );
  }
}

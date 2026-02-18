import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/startup/view_model/onboarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final styles = context.typography;
    final spacing = context.spacing;
    final radius = context.radius;
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /// Page View
            PageView.builder(
              controller: _pageController,
              itemCount: onboardingScreens.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                final screen = onboardingScreens[index];
                return Padding(
                  padding: EdgeInsets.all(spacing.xxl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(radius.xl),
                        child: Image.asset(screen.imagePath),
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
                );
              },
            ),

            /// Top Right Skip
            Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.lg,
                  vertical: spacing.md,
                ),
                child: TextButton(
                  onPressed: () {
                    GoRouter.of(context).go(AppRoutes.signup);
                  },
                  child: Text(
                    AppLocalizations.skip,
                    style: styles.label.copyWith(color: colors.primary),
                  ),
                ),
              ),
            ),

            /// Bottom Section (Indicators + Button)
            Positioned(
              bottom: spacing.xxl,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  /// Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingScreens.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: EdgeInsets.symmetric(
                          horizontal: spacing.xs / 2,
                        ),
                        width: _currentIndex == index ? spacing.lg : spacing.xs,
                        height: spacing.xs,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius.sm),
                          color: _currentIndex == index
                              ? colors.primary
                              : colors.divider,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: spacing.xxl),

                  /// Next Button
                  Container(
                    width: spacing.xxl + spacing.xl,
                    height: spacing.xxl + spacing.xl,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: spacing.xl,
                      ),
                      onPressed: () {
                        if (_currentIndex == onboardingScreens.length - 1) {
                          GoRouter.of(context).go(AppRoutes.signup);
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
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

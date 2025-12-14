import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/styling/app_colors.dart';
import 'package:cureta/core/styling/app_styles.dart';
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
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                         borderRadius: BorderRadius.circular(24),
                        child: Image.asset(screen.imagePath)),
                      const SizedBox(height: 24),
                      Text(
                        screen.title,
                        textAlign: TextAlign.center,
                        style: AppStyles.headingMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        screen.description,
                        textAlign: TextAlign.center,
                        style: AppStyles.bodyLarge,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextButton(
                  onPressed: () {
                    GoRouter.of(context).go(AppRoutes.signup);
                  },
                  child: Text(
                    'Skip',
                    style: AppStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),

            /// Bottom Section (Indicators + Button)
            Positioned(
              bottom: 32,
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
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentIndex == index
                              ? AppColors.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Next Button
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        if (_currentIndex ==
                            onboardingScreens.length - 1) {
                          GoRouter.of(context)
                              .go(AppRoutes.signup);
                        } else {
                          _pageController.nextPage(
                            duration:
                                const Duration(milliseconds: 300),
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

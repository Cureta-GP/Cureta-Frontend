import 'package:cureta/features/startup/view_model/onboarding_view_model.dart';
import 'package:cureta/features/startup/widgets/onboarding_indicator.dart';
import 'package:cureta/features/startup/widgets/onboarding_next_button.dart';
import 'package:cureta/features/startup/widgets/onboarding_page.dart';
import 'package:cureta/features/startup/widgets/onboarding_skip_button.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

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
    final spacing = context.spacing;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// Top Right Skip
            const OnboardingSkipButton(),

            /// Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingScreens.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(screen: onboardingScreens[index]);
                },
              ),
            ),
            SizedBox(height: spacing.xxl),

            /// Bottom Section (Indicators + Button)
            Padding(
              padding: EdgeInsets.only(bottom: spacing.xxl),
              child: Column(
                children: [
                  OnboardingIndicator(
                    itemCount: onboardingScreens.length,
                    currentIndex: _currentIndex,
                  ),
                  SizedBox(height: spacing.xxl),
                  OnboardingNextButton(
                    currentIndex: _currentIndex,
                    totalScreens: onboardingScreens.length,
                    pageController: _pageController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

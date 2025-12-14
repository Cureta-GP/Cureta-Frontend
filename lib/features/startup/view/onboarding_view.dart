import 'package:cureta/core/config/routing/app_routes.dart';
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
      body: PageView.builder(
        controller: _pageController,
        itemCount: onboardingScreens.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final screen = onboardingScreens[index];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(screen.imagePath),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    screen.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(screen.description, textAlign: TextAlign.center),
              ],
            ),
          );
        },
      ),
      bottomSheet: _currentIndex == onboardingScreens.length - 1
          ? TextButton(
              onPressed: () {
                // Navigate to your next screen
                GoRouter.of(context).go(AppRoutes.signup);
              },
              child: const Text('Get Started'),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _pageController.jumpToPage(onboardingScreens.length - 1);
                  },
                  child: const Text('Skip'),
                ),
                Row(
                  children: List.generate(
                    onboardingScreens.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
    );
  }
}

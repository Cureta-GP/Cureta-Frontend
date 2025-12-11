import 'package:cureta/core/constants/app_images.dart';

class OnboardingViewModel {
  final String imagePath;
  final String title;
  final String description;

  OnboardingViewModel({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

// بيانات الثلاث شاشات
final onboardingScreens = [
  OnboardingViewModel(
    imagePath:AppImages.onboardingScan,
    title: 'Welcome',
    description: 'This is the first onboarding screen',
  ),
  OnboardingViewModel(
    imagePath: AppImages.onboardingReminder,
    title: 'Explore',
    description: 'This is the second onboarding screen',
  ),
  OnboardingViewModel(
    imagePath: AppImages.onboardingQr,
    title: 'Get Started',
    description: 'This is the third onboarding screen',
  ),
];

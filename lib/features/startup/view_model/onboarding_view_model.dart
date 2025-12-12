import 'package:cureta/core/constants/app_images.dart';
import 'package:cureta/features/startup/model/onboarding_model.dart';

final onboardingScreens = [
  OnboardingModel(
    imagePath: AppImages.onboardingScan,
    title: 'Scan Prescriptions Instantly',
    description:
        'Use your camera to scan prescriptions and automatically extract medication information with OCR technology',
  ),
  OnboardingModel(
    imagePath: AppImages.onboardingReminder,
    title: 'Never Miss a Dose',
    description:
        'Get timely reminders for your medications and track your daily health journey with ease',
  ),
  OnboardingModel(
    imagePath: AppImages.onboardingQr,
    title: 'Your Health, One QR Away',
    description:
        'Store your medical history digitally and generate QR codes for easy sharing with healthcare providers',
  ),
];

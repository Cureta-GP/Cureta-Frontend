import 'package:cureta/core/constants/app_images.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/startup/model/onboarding_model.dart';

List<OnboardingModel> get onboardingScreens => [
  OnboardingModel(
    imagePath: AppImages.onboardingScan,
    title: AppLocalizations.onboardingScreen1Title,
    description: AppLocalizations.onboardingScreen1Description,
  ),
  OnboardingModel(
    imagePath: AppImages.onboardingReminder,
    title: AppLocalizations.onboardingScreen2Title,
    description: AppLocalizations.onboardingScreen2Description,
  ),
  OnboardingModel(
    imagePath: AppImages.onboardingQr,
    title: AppLocalizations.onboardingScreen3Title,
    description: AppLocalizations.onboardingScreen3Description,
  ),
];

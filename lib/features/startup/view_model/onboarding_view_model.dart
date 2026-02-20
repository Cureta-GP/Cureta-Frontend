import 'package:cureta/core/constants/app_images.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/startup/model/onboarding_model.dart';

List<OnboardingModel> get onboardingScreens => [
      // Screen 1: Your health, all in one place
      OnboardingModel(
        imagePath: AppImages.onboarding1,
        title: AppLocalizations.onboardingScreen1Title,
        description: AppLocalizations.onboardingScreen1Description,
      ),
      // Screen 2: Keep your medical history safe
      OnboardingModel(
        imagePath: AppImages.onboarding2,
        title: AppLocalizations.onboardingScreen2Title,
        description: AppLocalizations.onboardingScreen2Description,
      ),
      // Screen 3: Never Miss Your Medicine
      OnboardingModel(
        imagePath: AppImages.onboarding3,
        title: AppLocalizations.onboardingScreen3Title,
        description: AppLocalizations.onboardingScreen3Description,
      ),
      // Screen 4: Instant Medication Setup
      OnboardingModel(
        imagePath: AppImages.onboarding4,
        title: AppLocalizations.onboardingScreen4Title,
        description: AppLocalizations.onboardingScreen4Description,
      ),
      // Screen 5: Share your health info safely
      OnboardingModel(
        imagePath: AppImages.onboarding5,
        title: AppLocalizations.onboardingScreen5Title,
        description: AppLocalizations.onboardingScreen5Description,
      ),
      // Screen 6: Care for your family
      OnboardingModel(
        imagePath: AppImages.onboarding6,
        title: AppLocalizations.onboardingScreen6Title,
        description: AppLocalizations.onboardingScreen6Description,
      ),
      // Screen 7: Your personal health assistant
      OnboardingModel(
        imagePath: AppImages.onboarding7,
        title: AppLocalizations.onboardingScreen7Title,
        description: AppLocalizations.onboardingScreen7Description,
      ),
    ];

import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/constants/app_images.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/authentcation/data/repo/auth_repository.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }
// داخل SplashView
Future<void> _navigateToNext() async {
  await Future.delayed(const Duration(seconds: 2)); // وقت للأنيميشن

  // التحقق يتم "خلف الكواليس" واللوجو معروض
   final authRepo = getIt.get<AuthRepository>();
  final profileRepo = getIt.get<ProfileRepository>();
  final bool loggedIn = await authRepo.isLoggedIn();

 
  final bool hasProfiles = await profileRepo.hasProfiles(); 
  if (!mounted) return;

  if (loggedIn) {
    if (hasProfiles) {
      context.go(AppRoutes.mainNavigation);
    } else {
      context.go(AppRoutes.addProfile);
    }
  } else {
    context.go(AppRoutes.onboarding);
  }
}

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Image.asset(
          AppImages.logo,
          width: spacing.xxl * 6,
          height: spacing.xxl * 6,
        ),
      ),
    );
  }
}

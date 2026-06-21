import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/constants/app_images.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/authentcation/data/repo/auth_repository.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

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
    // تم إزالة الانتظار الوهمي (Future.delayed) لكي يفتح التطبيق بأسرع وقت ممكن

    // التحقق يتم "خلف الكواليس" واللوجو معروض
    final authRepo = getIt.get<AuthRepository>();
    final profileRepo = getIt.get<ProfileRepository>();
    final bool loggedIn = await authRepo.isLoggedIn();

    if (!mounted) return;

    if (loggedIn) {
      final hasProfiles = await profileRepo.hasProfiles();

      if (context.mounted) {
        if (hasProfiles) {
          context.go(AppRoutes.mainNavigation);
        } else {
          context.go(AppRoutes.addProfile);
        }
      }
    } else {
      // إذا لم يكن المستخدم مسجل دخول، اذهب إلى صفحة الـ onboarding
      context.go(AppRoutes.onboarding);
    }

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Image.asset(
          AppImages.logo,
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

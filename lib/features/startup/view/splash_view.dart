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

  if (!mounted) return;

  if (loggedIn) {
    // التحقق من وجود profile_id محفوظ في SharedPreferences
    final cachedProfileId = await profileRepo.getCachedProfileId();
    
    if (cachedProfileId != null && cachedProfileId.isNotEmpty) {
      // إذا كان هناك profile_id محفوظ، اذهب مباشرة إلى الـ home screen
      context.go(AppRoutes.mainNavigation);
    } else {
      // إذا لم يكن هناك profile_id محفوظ، اذهب إلى صفحة إنشاء البروفايل
      context.go(AppRoutes.addProfile);
    }
  } else {
    // إذا لم يكن المستخدم مسجل دخول، اذهب إلى صفحة الـ onboarding
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

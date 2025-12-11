import 'package:cureta/core/routing/app_routes.dart';
import 'package:cureta/features/startup/view/onboarding_view.dart';
import 'package:cureta/features/startup/view/splash_view.dart';
import 'package:go_router/go_router.dart';
class RoutesGeneration {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash ,
        name: AppRoutes.splash ,
        builder: (context, state) => SplashView(),
      ),

      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
    ],
  );
}
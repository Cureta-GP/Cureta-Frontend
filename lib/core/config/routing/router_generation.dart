import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/utils/page_transitions.dart';
import 'package:cureta/features/authentcation/veiw/forget_password_view.dart';
import 'package:cureta/features/authentcation/veiw/reset_password_view.dart';
import 'package:cureta/features/authentcation/veiw/signup_view.dart';
import 'package:cureta/features/authentcation/veiw/login_view.dart';
import 'package:cureta/features/authentcation/veiw/verify_email_view.dart';
import 'package:cureta/features/startup/view/onboarding_view.dart';
import 'package:cureta/features/startup/view/splash_view.dart';
import 'package:go_router/go_router.dart';

class RoutesGeneration {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (context, state) => SplashView(),
      ),

      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      // Home Page
      GoRoute(
        path: AppRoutes.signup,
        name: AppRoutes.signup,
        pageBuilder: (context, state) =>
            PageTransitions.scale(child: const SignupView(), state: state),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.login,
        pageBuilder: (context, state) =>
            PageTransitions.scale(child: const LoginView(), state: state),
      ),
      GoRoute(
        path: AppRoutes.forgetPassword,
        name: AppRoutes.forgetPassword,
        pageBuilder: (context, state) =>
            PageTransitions.fade(child: ForgetPasswordView(), state: state),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        name: AppRoutes.verifyEmail,
        pageBuilder: (context, state) =>
            PageTransitions.fade(child: VerifyEmailView(), state: state),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        name: AppRoutes.resetPassword,
        pageBuilder: (context, state) =>
            PageTransitions.fade(child: ResetPasswordView(), state: state),
      ),

      
    ],
  );
}

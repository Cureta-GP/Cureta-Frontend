import 'package:cureta/core/utils/page_transitions.dart';
import 'package:cureta/features/authentcation/veiw/SignupPage.dart';
import 'package:cureta/features/authentcation/veiw/login.dart';
import 'package:go_router/go_router.dart';
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.signup,
    routes: [
      // Home Page
      GoRoute(
        path: AppRoutes.signup,
        name: AppRoutes.signup,
        pageBuilder: (context, state) => PageTransitions.fade(
          child: const SignupPage(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.login,
        pageBuilder: (context, state) => PageTransitions.fade(
          child: const LoginPage(),
          state: state,
        ),
      ),

      // Profile Page
      /*GoRoute(
        path: AppRoutes.signup,
        name: AppRoutes.signup,
        pageBuilder: (context, state) => PageTransitions.slideLeft(
          child: const SignupPage(),
          state: state,
        ),
      ),

      // Settings Page
      GoRoute(
        path: AppRoutes.signup,
        name: AppRoutes.signup,
        pageBuilder: (context, state) => PageTransitions.slideUp(
          child: const SignupPage(),
          state: state,
        ),
      ),

      // Details Page with ID parameter
      GoRoute(
        path: AppRoutes.signup,
        name: AppRoutes.signup,
        pageBuilder: (context, state) {
          return PageTransitions.slideRight(
            child: const SignupPage(),
            state: state,
          );
        },
      ),*/
    ],
  );
}

/// Route paths - مسارات الصفحات
class AppRoutes {
  static const String signup = '/signup';
  static const String login = '/login';
}
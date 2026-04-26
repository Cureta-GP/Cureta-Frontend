import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/utils/page_transitions.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/features/authentcation/veiw/forget_password_view.dart';
import 'package:cureta/features/authentcation/veiw/reset_password_view.dart';
import 'package:cureta/features/authentcation/veiw/signup_view.dart';
import 'package:cureta/features/authentcation/veiw/login_view.dart';
import 'package:cureta/features/authentcation/veiw/verify_email_view.dart';
import 'package:cureta/features/chat_bot/veiw/Chat_screen.dart';
import 'package:cureta/features/home/view/home_view.dart';
import 'package:cureta/features/home/view/main_navigation_views.dart';
import 'package:cureta/features/authentcation/veiw_model/forgot_password_view_model.dart';
import "package:cureta/features/medical_records/veiw/User's_Records.dart";
import 'package:cureta/features/medical_records/veiw/add_medical_record_seconed_step.dart';
import 'package:cureta/features/medicines/view/medicines_main_view.dart';
import 'package:cureta/features/ocr/view/scan_prescription_screen.dart';
import 'package:cureta/features/ocr/view/scanned_medicines_screen.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:cureta/features/profile/view/add_profile_main_view.dart';
import 'package:cureta/features/medical_records/veiw/add_record_first_step.dart';
import 'package:cureta/features/medical_records/veiw/add_record_forth_step.dart';
import 'package:cureta/features/medical_records/veiw/add_record_step_fifth.dart';
import 'package:cureta/features/medical_records/veiw/add_record_third_step.dart';
import 'package:cureta/features/medical_records/veiw/add_record_flow_wrapper.dart';
import 'package:cureta/features/medical_records/veiw/record_details_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/features/medical_records/data/models/medical_record_model.dart';
import 'package:cureta/features/medical_records/veiw_model/medical_records_cubit.dart';
import 'package:cureta/features/profile/data/models/profile_model.dart';
import 'package:cureta/features/profile/view_model/profile_state.dart';
import 'package:cureta/features/startup/view/onboarding_view.dart';
import 'package:cureta/features/startup/view/splash_view.dart';
import 'package:go_router/go_router.dart';

class RoutesGeneration {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    /*  redirect: (context, state) async {
  final authRepo = getIt.get<AuthRepository>();
  final bool loggedIn = await authRepo.isLoggedIn();
  final String currentLocation = state.matchedLocation;

  // 1. لو مش عامل Login
  if (!loggedIn) {
    // لو هو في صفحة الـ Auth (Login/Signup/Splash/Onboarding) سيبيه مكانه
    final bool isAuthRoute = currentLocation == AppRoutes.login || 
                             currentLocation == AppRoutes.signup ||
                             currentLocation == AppRoutes.splash ||
                             currentLocation == AppRoutes.onboarding;
    return isAuthRoute ? null : AppRoutes.login;
  }

  // 2. لو عامل Login، نتحقق من البروفايل
  final profileRepo = getIt.get<ProfileRepository>();
  final bool hasProfiles = await profileRepo.hasProfiles(); 

  // لو معندوش بروفايل وهو لسه مش في صفحة "إضافة بروفايل" -> واديه يضيف بروفايل
  if (!hasProfiles && currentLocation != AppRoutes.addProfile) {
    return AppRoutes.addProfile;
  }

  // لو عنده بروفايل وبيحاول يدخل صفحات الـ Auth (زي اللوجن) -> واديه المين
  final bool isAuthRoute = currentLocation == AppRoutes.login || 
                           currentLocation == AppRoutes.signup;
  if (hasProfiles && isAuthRoute) {
    return AppRoutes.mainNavigation;
  }

  return null; // كمل في طريقك عادي
},*/
    debugLogDiagnostics: true,
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
      // OCR Scan Prescription
      GoRoute(
        path: AppRoutes.scanPrescription,
        name: AppRoutes.scanPrescription,
        builder: (context, state) => const ScanPrescriptionScreen(),
      ),
      GoRoute(
        path: AppRoutes.scannedMedicines,
        name: AppRoutes.scannedMedicines,
        builder: (context, state) => const ScannedMedicinesScreen(),
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
      // Forgot Password Flow - Shared Cubit via ShellRoute
      ShellRoute(
        builder: (context, state, child) => BlocProvider(
          create: (context) => getIt<ForgotPasswordViewModel>(),
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.forgetPassword,
            name: AppRoutes.forgetPassword,
            pageBuilder: (context, state) =>
                PageTransitions.fade(child: ForgetPasswordView(), state: state),
          ),
          GoRoute(
            path: AppRoutes.verifyEmail,
            name: AppRoutes.verifyEmail,
            pageBuilder: (context, state) => PageTransitions.fade(
              child: VerifyEmailView(email: state.extra as String? ?? ''),
              state: state,
            ),
          ),
          GoRoute(
            path: AppRoutes.resetPassword,
            name: AppRoutes.resetPassword,
            pageBuilder: (context, state) =>
                PageTransitions.fade(child: ResetPasswordView(), state: state),
          ),
        ],
      ),
      // Medical Records Flow - Shared Cubits via ShellRoute
      ShellRoute(
        builder: (context, state, child) => AddRecordFlowWrapper(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.medicalRecordsStepOne,
            name: AppRoutes.medicalRecordsStepOne,
            pageBuilder: (context, state) => PageTransitions.fade(
              child: const AddRecordFirstStep(),
              state: state,
            ),
          ),
          GoRoute(
            path: AppRoutes.medicalRecordsStepTwo,
            name: AppRoutes.medicalRecordsStepTwo,
            pageBuilder: (context, state) => PageTransitions.slideRight(
              child: const AddMedicalRecordSeconedStep(),
              state: state,
            ),
          ),
          GoRoute(
            path: AppRoutes.medicalRecords_step_three,
            name: AppRoutes.medicalRecords_step_three,
            pageBuilder: (context, state) => PageTransitions.slideRight(
              child: const AddRecordThirdStep(),
              state: state,
            ),
          ),
          GoRoute(
            path: AppRoutes.addRecordStepFour,
            name: AppRoutes.addRecordStepFour,
            pageBuilder: (context, state) => PageTransitions.slideRight(
              child: const AddRecordForthStep(),
              state: state,
            ),
          ),
          GoRoute(
            path: AppRoutes.addRecordStepFive,
            name: AppRoutes.addRecordStepFive,
            pageBuilder: (context, state) => PageTransitions.slideRight(
              child: const AddRecordStepFifth(),
              state: state,
            ),
          ),
        ],
      ),
      // Home Page
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        pageBuilder: (context, state) => PageTransitions.fade(
          child: HomeView(onMenuPressed: () {}),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutes.addProfile,
        name: AppRoutes.addProfile,
        redirect: (context, state) async {
          final extra = state.extra;
          final bool isFamily = extra is bool ? extra : false;
          if (extra is! ProfileModel) {
            final hasProfiles = await getIt
                .get<ProfileRepository>()
                .hasProfiles();
            if (hasProfiles && !isFamily) {
              return AppRoutes.mainNavigation;
            }
          }
          return null;
        },
        pageBuilder: (context, state) {
          final extra = state.extra;
          final bool isFamily = extra is bool ? extra : false;
          final ProfileModel? editingProfile = extra is ProfileModel
              ? extra
              : null;

          return PageTransitions.fade(
            child: AddProfileMain(
              isFamilyMember: editingProfile?.isPrimary == false || isFamily,
              editingProfile: editingProfile,
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.userRecords,
        name: AppRoutes.userRecords,
        pageBuilder: (context, state) => PageTransitions.scale(
          child: const UserRecordsView(isActive: true),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutes.medicines,
        name: AppRoutes.medicines,
        pageBuilder: (context, state) => PageTransitions.scale(
          child: const MedicinesMainView(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutes.mainNavigation,
        name: AppRoutes.mainNavigation,
        pageBuilder: (context, state) {
          final extra = state.extra;
          final ProfileState profileModel;
          final tabFromQuery = int.tryParse(
            state.uri.queryParameters['tab'] ?? '',
          );
          int initialTabIndex = tabFromQuery ?? 0;

          if (extra is ProfileState) {
            profileModel = extra;
          } else if (extra is ProfileModel) {
            profileModel = ProfileState(
              name: extra.fullName,
              gender: extra.gender,
              relationship: extra.relationship,
              age: extra.age,
              bloodType: extra.bloodType,
              isAddingFamilyMember: !extra.isPrimary,
            );
          } else if (extra is Map) {
            final profileExtra = extra['profile'];
            final tabExtra = extra['tabIndex'];

            if (tabExtra is int) {
              initialTabIndex = tabExtra;
            }

            if (profileExtra is ProfileState) {
              profileModel = profileExtra;
            } else if (profileExtra is ProfileModel) {
              profileModel = ProfileState(
                name: profileExtra.fullName,
                gender: profileExtra.gender,
                relationship: profileExtra.relationship,
                age: profileExtra.age,
                bloodType: profileExtra.bloodType,
                isAddingFamilyMember: !profileExtra.isPrimary,
              );
            } else {
              profileModel = ProfileState(isAddingFamilyMember: false);
            }
          } else {
            profileModel = ProfileState(isAddingFamilyMember: false);
          }

          return PageTransitions.scale(
            child: MainNavigationScreen(
              profile: profileModel,
              initialTabIndex: initialTabIndex,
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.recordDetails,
        name: AppRoutes.recordDetails,
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          final record = data['record'] as MedicalRecordModel?;
          final recordsCubit = data['recordsCubit'] as MedicalRecordsCubit?;
          final page = RecordDetailsView(
            record: record,
            conditionName: data['conditionName'] ?? '',
            isOngoing: data['isOngoing'] ?? false,
            diagnosedDate: data['diagnosedDate'] ?? '',
            notes: data['notes'] ?? '',
          );

          return PageTransitions.scale(
            child: recordsCubit != null
                ? BlocProvider<MedicalRecordsCubit>.value(
                    value: recordsCubit,
                    child: page,
                  )
                : page,
            state: state,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.chat,
        name: AppRoutes.chat,
        pageBuilder: (context, state) =>
            PageTransitions.fade(child: const ChatScreen(), state: state),
      ),
    ],
  );
}

import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/utils/page_transitions.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/features/Meds/view/medicines_main_view.dart';
import 'package:cureta/features/authentcation/veiw/forget_password_view.dart';
import 'package:cureta/features/authentcation/veiw/reset_password_view.dart';
import 'package:cureta/features/authentcation/veiw/signup_view.dart';
import 'package:cureta/features/authentcation/veiw/login_view.dart';
import 'package:cureta/features/authentcation/veiw/verify_email_view.dart';
import 'package:cureta/features/chat_bot/veiw/Chat_screen.dart';
import 'package:cureta/features/home/view/home_view.dart';
import 'package:cureta/features/home/view/main_navigation_views.dart';
import "package:cureta/features/medical_records/veiw/User's_Records.dart";
import 'package:cureta/features/medical_records/veiw/add_medical_record_seconed_step.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:cureta/features/profile/view/add_profile_main_view.dart';
import 'package:cureta/features/medical_records/veiw/add_record_first_step.dart';
import 'package:cureta/features/medical_records/veiw/add_record_forth_step.dart';
import 'package:cureta/features/medical_records/veiw/add_record_step_fifth.dart';
import 'package:cureta/features/medical_records/veiw/add_record_third_step.dart';
import 'package:cureta/features/medical_records/veiw/add_record_flow_wrapper.dart';
import 'package:cureta/features/medical_records/veiw/record_details_screen.dart';
import 'package:cureta/features/medical_records/widgets/record_details_documents_section.dart';
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
  final profileRepo = getIt.get<ProfileRepository>();
  final bool loggedIn = await authRepo.isLoggedIn();

 
  final bool hasProfiles = await profileRepo.hasProfiles(); 

  final bool isAuthRoute = state.matchedLocation == AppRoutes.login || 
                           state.matchedLocation == AppRoutes.signup ||
                           state.matchedLocation == AppRoutes.splash ||
                           state.matchedLocation == AppRoutes.onboarding;

  if (loggedIn && !hasProfiles) {
     if (state.matchedLocation != AppRoutes.addProfile) {
       return AppRoutes.addProfile;
     }
  }

  if (loggedIn && hasProfiles && isAuthRoute && state.matchedLocation != AppRoutes.splash) {
    return AppRoutes.mainNavigation;
  }

  return null; 
},*/
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
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        pageBuilder: (context, state) =>
            PageTransitions.fade(child: const HomeView(), state: state),
      ),
      GoRoute(
        path: AppRoutes.addProfile,
        name: AppRoutes.addProfile,
        redirect: (context, state) async {
          final isFamily = state.extra as bool? ?? false;
          final hasProfiles = await getIt
              .get<ProfileRepository>()
              .hasProfiles();
          if (hasProfiles && !isFamily) {
            return AppRoutes.mainNavigation;
          }
          return null;
        },
        pageBuilder: (context, state) {
          final bool isFamily = state.extra as bool? ?? false;
          return PageTransitions.fade(
            child: AddProfileMain(isFamilyMember: isFamily),
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
          } else {
            profileModel = ProfileState(isAddingFamilyMember: false);
          }

          return PageTransitions.scale(
            child: MainNavigationScreen(profile: profileModel),
            state: state,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.recordDetails,
        name: AppRoutes.recordDetails,
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          final rawFiles = data['files'];
          final files = rawFiles is List
              ? rawFiles.whereType<RecordFile>().toList()
              : <RecordFile>[];
          return PageTransitions.scale(
            child: RecordDetailsView(
              conditionName: data['conditionName'] ?? '',
              isOngoing: data['isOngoing'] ?? false,
              diagnosedDate: data['diagnosedDate'] ?? '',
              notes: data['notes'] ?? '',
              files: files,
            ),
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

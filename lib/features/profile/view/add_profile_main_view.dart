import 'package:cureta/features/profile/view/steps/age_step_view.dart';
import 'package:cureta/features/profile/view/steps/blood_type_step_view.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/profile/view/steps/medical_conditions_step_view.dart';
import 'package:cureta/features/profile/view_model/profile_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_state.dart';
import 'package:cureta/shared/widgets/progress_step_layout.dart';
import 'package:cureta/features/profile/view/steps/name_step_view.dart';
import 'package:cureta/features/profile/view/steps/gender_step_view.dart';
import 'package:cureta/features/profile/view/steps/relation_step_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/core/config/routing/app_routes.dart';

class AddProfileMain extends StatelessWidget {
  final bool isFamilyMember;
  const AddProfileMain({super.key, this.isFamilyMember = false});

  List<Map<String, String>> _getStepsContent(BuildContext context) => [
    {
      "title": AppLocalizations.profilesNameTitle,
      "subtitle": AppLocalizations.profilesNameSubtitle,
    },
    {
      "title": AppLocalizations.profilesGenderTitle,
      "subtitle": AppLocalizations.profilesGenderSubtitle,
    },
    {
      "title": AppLocalizations.profilesRelationTitle,
      "subtitle": AppLocalizations.profilesRelationSubtitle,
    },
    {
      "title": AppLocalizations.profilesAgeTitle,
      "subtitle": AppLocalizations.profilesAgeSubtitle,
    },
    {
      "title": AppLocalizations.profilesBloodTypeTitle,
      "subtitle": AppLocalizations.profilesBloodTypeSubtitle,
    },
    {
      "title": AppLocalizations.profilesMedicalConditionsChronicTitle,
      "subtitle": AppLocalizations.profilesMedicalConditionsChronicSubtitle,
    },
    {
      "title": AppLocalizations.profilesMedicalConditionsAllergiesTitle,
      "subtitle": AppLocalizations.profilesMedicalConditionsAllergiesSubtitle,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final steps = _getStepsContent(context);

    return BlocProvider(
      create: (context) => ProfileCubit(isFamilyMember: isFamilyMember),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();

          return ProgressStepLayout(
            appBarTitle: AppLocalizations.profilesAddProfile,
            title: steps[state.currentPage]["title"]!,
            subtitle: steps[state.currentPage]["subtitle"],
            stepLabel: AppLocalizations.profilesStepIndicator(
              state.currentPage + 1,
              7,
            ),
            progressLabel: "${((state.currentPage + 1) / 7 * 100).toInt()}%",
            progress: (state.currentPage + 1) / 7,
            onNext: () {
              if (state.currentPage == 6) {
                GoRouter.of(context).go(AppRoutes.mainNavigation, extra: state);
              } else {
                cubit.nextStep(pageController);
              }
            },
            onBack: () {
              if (state.currentPage == 0) {
                context.pop();
              } else {
                cubit.previousStep(pageController);
              }
            },
            child: SizedBox(
              height: 450,
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  NameInputStep(),
                  GenderSelectionStep(),
                  RelationSelectionStep(),
                  AgeStep(),
                  BloodTypeStep(),
                  MedicalConditionsStep(type: MedicalConditionType.chronic),
                  MedicalConditionsStep(type: MedicalConditionType.allergy),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

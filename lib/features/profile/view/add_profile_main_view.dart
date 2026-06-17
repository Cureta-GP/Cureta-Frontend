import '../widgets/step_page_view.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/features/profile/data/models/allergy_option.dart';
import 'package:cureta/features/profile/data/models/chronic_disease_option.dart';
import 'package:cureta/features/profile/data/models/profile_model.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
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

class AddProfileMain extends StatefulWidget {
  final bool isFamilyMember;
  final ProfileModel? editingProfile;
  const AddProfileMain({
    super.key,
    this.isFamilyMember = false,
    this.editingProfile,
  });

  @override
  State<AddProfileMain> createState() => _AddProfileMainState();
}

class _AddProfileMainState extends State<AddProfileMain> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
    final steps = _getStepsContent(context);
    final isEditing = widget.editingProfile != null;
    final chronicParse = _parseConditions(
      widget.editingProfile?.chronicDiseases,
      MedicalConditionType.chronic,
    );
    final allergyParse = _parseConditions(
      widget.editingProfile?.allergies,
      MedicalConditionType.allergy,
    );

    final initialState = widget.editingProfile != null
        ? ProfileState(
            name: widget.editingProfile!.fullName,
            gender: widget.editingProfile!.gender,
            relationship: widget.editingProfile!.relationship,
            age: widget.editingProfile!.age,
            bloodType: widget.editingProfile!.bloodType,
            chronicConditions: chronicParse.selectedValues,
            allergies: allergyParse.selectedValues,
            otherChronicText: chronicParse.otherText,
            otherAllergyText: allergyParse.otherText,
            currentPage: 0,
            isAddingFamilyMember: !widget.editingProfile!.isPrimary,
          )
        : null;
    final effectiveFamilyMember =
        widget.editingProfile?.isPrimary == false || widget.isFamilyMember;

    return BlocProvider(
      create: (_) => ProfileCubit(
        repository: getIt.get<ProfileRepository>(),
        initialState: initialState,
        isFamilyMember: effectiveFamilyMember,
      ),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();

          return ProgressStepLayout(
            appBarTitle: isEditing
                ? 'Edit Profile'
                : AppLocalizations.profilesAddProfile,
            title: steps[state.currentPage]["title"]!,
            subtitle: steps[state.currentPage]["subtitle"],
            stepLabel: AppLocalizations.profilesStepIndicator(
              state.currentPage + 1,
              7,
            ),
            progressLabel: "${((state.currentPage + 1) / 7 * 100).toInt()}%",
            progress: (state.currentPage + 1) / 7,
            onNext: () async {
              if (state.currentPage == 6) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );

                try {
                  final profile = isEditing
                      ? await cubit.updateProfile(widget.editingProfile!.id)
                      : await cubit.createProfile();
                  if (!mounted) return;
                  Navigator.pop(context); // غلق Loading
                  if (GoRouter.of(context).canPop()) {
                    GoRouter.of(context).pop(profile);
                  } else {
                    GoRouter.of(
                      context,
                    ).go(AppRoutes.mainNavigation, extra: profile);
                  }
                } catch (e) {
                  if (!mounted) return;
                  Navigator.pop(context); 
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save profile: $e')),
                  );
                }
              } else {
                cubit.nextStep(_pageController);
              }
            },
            onBack: () {
              if (state.currentPage == 0) {
                context.pop();
              } else {
                cubit.previousStep(_pageController);
              }
            },
            child: StepPageView(
              controller: _pageController,
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
          );
        },
      ),
    );
  }

  _ConditionParseResult _parseConditions(
    List<dynamic>? values,
    MedicalConditionType type,
  ) {
    final knownItems = type == MedicalConditionType.chronic
        ? ChronicDiseaseOption.values.map((e) => e.backendName).toSet()
        : AllergyOption.values.map((e) => e.backendName).toSet();

    final selected = <String>{};
    String otherText = '';

    if (values == null) return _ConditionParseResult(selected, otherText);

    for (final item in values) {
      String value;
      if (item is Map<String, dynamic>) {
        value =
            item['description']?.toString() ?? item['name']?.toString() ?? '';
      } else {
        value = item.toString();
      }
      if (value.isEmpty) continue;

      if (knownItems.contains(value)) {
        selected.add(value);
      } else if (value == 'other') {
        // Literal 'other' without custom text
        selected.add('other');
      } else {
        // Custom text - select 'other' and store the custom text
        selected.add('other');
        otherText = value;
      }
    }

    return _ConditionParseResult(selected, otherText);
  }
}

class _ConditionParseResult {
  final Set<String> selectedValues;
  final String otherText;

  _ConditionParseResult(this.selectedValues, this.otherText);
}

import 'package:cureta/features/profile/view/steps/age_step_view.dart';
import 'package:cureta/features/profile/view/steps/blood_type_step_view.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/profile/view/steps/medical_conditions_step_view.dart';
import 'package:cureta/shared/widgets/progress_step_layout.dart';
import 'package:cureta/features/profile/view/steps/name_step_view.dart';
import 'package:cureta/features/profile/view/steps/gender_step_view.dart';
import 'package:cureta/features/profile/view/steps/relation_step_view.dart';
import 'package:flutter/material.dart';

class AddProfileMain extends StatefulWidget {
  const AddProfileMain({super.key});

  @override
  State<AddProfileMain> createState() => _AddProfileMainState();
}

class _AddProfileMainState extends State<AddProfileMain> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalSteps = 7;

  List<Map<String, String>> get _stepsContent => [
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

  void _onNext() {
    if (_currentPage < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return ProgressStepLayout(
      appBarTitle: AppLocalizations.profilesAddProfile,
      title: _stepsContent[_currentPage]["title"]!,
      subtitle: _stepsContent[_currentPage]["subtitle"],
      stepLabel: AppLocalizations.profilesStepIndicator(
        _currentPage + 1,
        _totalSteps,
      ),
      progressLabel: "${((_currentPage + 1) / _totalSteps * 100).toInt()}%",
      progress: (_currentPage + 1) / _totalSteps,
      child: SizedBox(
        height: 300,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (int page) {
            setState(() => _currentPage = page);
          },
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
      onNext: _onNext,
      onSkip: () {},
      onBack: () {
        if (_currentPage > 0) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          Navigator.maybePop(context);
        }
      },
    );
  }
}

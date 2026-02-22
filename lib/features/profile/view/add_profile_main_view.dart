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
  // 1. التحكم في الصفحات
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalSteps = 7;

  // 2. الداتا المتغيرة لكل صفحة (العنوان والوصف)
  final List<Map<String, String>> _stepsContent = [
    {
      "title": "What is the full name?",
      "subtitle": "We'll use this to personalize the health dashboard."
    },
    {
      "title": "What is the gender?",
      "subtitle": "This helps us provide relevant health insights."
    },
    {
      "title": "How are they related to you?",
      "subtitle": "Select your relationship to this person."
    },
    {
      "title": "How old are they?",
      "subtitle": "Enter the age to help us calculate metrics."
    },
    {
      "title": "What is their blood type?",
      "subtitle": "Knowing the blood type is crucial for emergencies."
    },
    {
      "title": "Any chronic diseases?",
      "subtitle": "Select any existing health conditions."
    },
    {
      "title": "Any allergies?",
      "subtitle": "Tell us about any known allergies."
    },
  ];

  void _onNext() {
    if (_currentPage < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // هنا لما يخلص الـ 7 خطوات (مثلاً يروح للـ Home)
    }
  }

  @override
  Widget build(BuildContext context) {

    return ProgressStepLayout(
      appBarTitle: "Add Profile",
      title: _stepsContent[_currentPage]["title"]!,
      subtitle: _stepsContent[_currentPage]["subtitle"],
      stepLabel: "Step ${_currentPage + 1} of $_totalSteps",
      progressLabel: "${((_currentPage + 1) / _totalSteps * 100).toInt()}%",
      progress: (_currentPage + 1) / _totalSteps,
      child: SizedBox(
        height: 300, // Fixed height for demo/placeholder
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
            // Add more steps as needed
            Center(child: Text("Step 4")),
            Center(child: Text("Step 5")),
            Center(child: Text("Step 6")),
            Center(child: Text("Step 7")),
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
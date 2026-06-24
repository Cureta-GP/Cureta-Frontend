import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_form_cubit.dart';
import 'package:cureta/features/medical_records/widgets/add_record_condition_section.dart';
import 'package:cureta/shared/widgets/add_record_next_button.dart';
import 'package:cureta/shared/widgets/step_progress_indicator.dart';
import 'package:cureta/shared/widgets/custom_screen_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddRecordFirstStep extends StatefulWidget {
  const AddRecordFirstStep({
    super.key,
    this.onBack,
    this.onCancel,
    this.onNext,
  });
  final VoidCallback? onBack;
  final VoidCallback? onCancel;
  final ValueChanged<String>? onNext;
  @override
  State<AddRecordFirstStep> createState() => _AddRecordFirstStepState();
}

class _AddRecordFirstStepState extends State<AddRecordFirstStep> {
  final TextEditingController _conditionController = TextEditingController();
  bool _showConditionError = false;

  @override
  void initState() {
    super.initState();
    _conditionController.addListener(_onConditionChanged);
  }

  void _onConditionChanged() {
    if (_showConditionError && _conditionController.text.isNotEmpty) {
      setState(() => _showConditionError = false);
    }
  }

  @override
  void dispose() {
    _conditionController.removeListener(_onConditionChanged);
    _conditionController.dispose();
    super.dispose();
  }

  void _handleNext() {
    final condition = _conditionController.text.trim();
    // Condition is required — show inline error instead of snackbar
    if (condition.isEmpty) {
      setState(() => _showConditionError = true);
      return;
    }
    setState(() => _showConditionError = false);
    // Explicitly unfocus before navigating so it doesn't autofocus when returning
    FocusManager.instance.primaryFocus?.unfocus();

    // Persist to shared cubit
    context.read<AddRecordFormCubit>().setCondition(condition);

    widget.onNext?.call(condition);
    GoRouter.of(context).pushNamed(AppRoutes.medicalRecordsStepTwo);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final horizontalPadding = spacing.xl;

    return Scaffold(
      backgroundColor: colors.background,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            spacing.md,
            horizontalPadding,
            spacing.lg,
          ),
          child: AddRecordNextButton(onPressed: _handleNext),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomScreenHeader(
              title: '',
              onBack:
                  widget.onBack ??
                  () {
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StepProgressIndicator(
                      stepLabel: AppLocalizations.addRecordStepLabel,
                      progressLabel: AppLocalizations.addRecordProgressLabel,
                      progress: 0.2,
                    ),
                    SizedBox(height: spacing.xxl),
                    AddRecordConditionSection(
                      controller: _conditionController,
                      errorText: _showConditionError
                          ? AppLocalizations.addRecordErrorConditionRequired
                          : null,
                    ),
                    SizedBox(height: spacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

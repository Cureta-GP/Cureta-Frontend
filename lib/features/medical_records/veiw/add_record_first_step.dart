import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_form_cubit.dart';
import 'package:cureta/features/medical_records/widgets/add_record_condition_section.dart';
import 'package:cureta/shared/widgets/add_record_next_button.dart';
import 'package:cureta/shared/widgets/step_progress_indicator.dart';
import 'package:cureta/shared/widgets/custom_top_bar.dart';
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
  @override
  void dispose() {
    _conditionController.dispose();
    super.dispose();
  }
  void _handleNext() {
    final condition = _conditionController.text.trim();
    // Condition is required
    if (condition.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a condition')));
      return;
    }
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
            CustomTopBar(
              onBack: widget.onBack,
              onAction: widget.onCancel,
              actionLabel: AppLocalizations.addRecordCancel,
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
                    AddRecordConditionSection(controller: _conditionController),
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

import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/medical_records/widgets/add_record_condition_section.dart';
import 'package:cureta/features/medical_records/widgets/add_record_next_button.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_progress.dart';
import 'package:cureta/features/medical_records/widgets/add_record_top_bar.dart';
import 'package:flutter/material.dart';
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
    widget.onNext?.call(_conditionController.text.trim());
    GoRouter.of(context).pushNamed(AppRoutes.medicalRecords_step_two);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final horizontalPadding = spacing.xl;

    return Scaffold(
      backgroundColor: colors.medicalRecordBackground,
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
            AddRecordTopBar(onBack: widget.onBack, onCancel: widget.onCancel),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AddRecordStepProgress(
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

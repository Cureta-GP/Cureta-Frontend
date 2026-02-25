import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/widgets/add_record_notes_card.dart';
import 'package:cureta/features/medical_records/widgets/add_record_screen_header.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_two_bottom_bar.dart';
import 'package:cureta/shared/widgets/add_record_step_progress.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddRecordThirdStep extends StatefulWidget {
  const AddRecordThirdStep({
    super.key,
    this.onBack,
    this.onContinue,
    this.onSkip,
  });

  final VoidCallback? onBack;
  final ValueChanged<String>? onContinue;
  final VoidCallback? onSkip;

  @override
  State<AddRecordThirdStep> createState() => _AddRecordThirdStepState();
}

class _AddRecordThirdStepState extends State<AddRecordThirdStep> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    widget.onContinue?.call(_notesController.text.trim());
    GoRouter.of(context).pushNamed(AppRoutes.addRecordStepFour);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Scaffold(
      backgroundColor: colors.medicalRecordBackground,
      body: SafeArea(
        child: Column(
          children: [
            AddRecordScreenHeader(
              title: AppLocalizations.addRecordStep3Label,
              onBack: widget.onBack,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                children: [
                  AddRecordStepProgress(
                    stepLabel: AppLocalizations.addRecordStep3Label,
                    progressLabel: AppLocalizations.addRecordProgress60,
                    progress: 0.6,
                  ),
                  SizedBox(height: spacing.xxl),
                  Text(
                    AppLocalizations.addRecordAdditionalNotesTitle,
                    style: typography.medicalRecordQuestion.copyWith(
                      color: colors.medicalRecordStrongText,
                    ),
                  ),
                  SizedBox(height: spacing.sm),
                  Text(
                    AppLocalizations.addRecordAdditionalNotesDescription,
                    style: typography.medicalRecordHelper.copyWith(
                      color: colors.medicalRecordMuted,
                    ),
                  ),
                  SizedBox(height: spacing.xl),
                  AddRecordNotesCard(controller: _notesController),
                  SizedBox(height: spacing.xl),
                  AddRecordStepTwoBottomBar(
                    onNext: _handleContinue,
                    onSkip: widget.onSkip,
                    nextLabel: AppLocalizations.addRecordContinue,
                  ),
                  //SizedBox(height: spacing.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
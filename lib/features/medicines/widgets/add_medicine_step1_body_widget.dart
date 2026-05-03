import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/features/medicines/widgets/medicine_name_field_widget.dart';
import 'package:cureta/features/medicines/widgets/medicine_validation_error_widget.dart';
import 'package:cureta/shared/widgets/add_record_next_button.dart';
import 'package:cureta/shared/widgets/custom_top_bar.dart';
import 'package:cureta/shared/widgets/step_progress_indicator.dart';

/// Scaffold body for Step 1 of the add-medicine flow.
class AddMedicineStep1BodyWidget extends StatelessWidget {
  const AddMedicineStep1BodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Scaffold(
      backgroundColor: colors.chatBackground,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            spacing.xl, spacing.md, spacing.xl, spacing.lg,
          ),
          child: AddRecordNextButton(
            onPressed: () => context.read<AddMedicineCubit>().validateStep1(),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomTopBar(onBack: () => context.pop()),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: spacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StepProgressIndicator(
                      stepLabel: AppLocalizations.medicinesStep1Of5,
                      progressLabel: AppLocalizations.medicinesStep1Progress,
                      progress: 0.2,
                    ),
                    SizedBox(height: spacing.xxl),
                    Text(
                      AppLocalizations.medicinesStep1Question,
                      style: typography.medicalRecordQuestion.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: spacing.sm),
                    Text(
                      AppLocalizations.medicinesStep1Subtitle,
                      style: typography.medicalRecordPickerLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: spacing.xl),
                    const MedicineNameFieldWidget(),
                    const MedicineValidationErrorWidget(
                      fieldKey: 'medicineName',
                    ),
                    SizedBox(height: spacing.lg),
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: colors.textHint, size: 16),
                        SizedBox(width: spacing.sm),
                        Text(
                          AppLocalizations.medicinesStep1InfoHint,
                          style: typography.medicalRecordHelper.copyWith(
                            color: colors.textHint,
                          ),
                        ),
                      ],
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

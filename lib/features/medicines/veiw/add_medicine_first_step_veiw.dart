import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state_mapper.dart';
import 'package:cureta/shared/widgets/add_record_next_button.dart';
import 'package:cureta/shared/widgets/custom_top_bar.dart';
import 'package:cureta/shared/widgets/step_progress_indicator.dart';

class AddMedicineFirstStepVeiw extends StatelessWidget {
  const AddMedicineFirstStepVeiw({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final cubit = context.read<AddMedicineCubit>();
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.radius.xl),
        ),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.medicinesPickImageTitle,
                style: typography.title.copyWith(color: colors.textPrimary),
              ),
              SizedBox(height: spacing.lg),
              ListTile(
                leading: Icon(Icons.camera_alt, color: colors.primary),
                title: Text(
                  AppLocalizations.medicinesPickFromCamera,
                  style: typography.body.copyWith(color: colors.textPrimary),
                ),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _pickFromSource(ImageSource.camera, cubit);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: colors.primary),
                title: Text(
                  AppLocalizations.medicinesPickFromGallery,
                  style: typography.body.copyWith(color: colors.textPrimary),
                ),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _pickFromSource(ImageSource.gallery, cubit);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Picks image from [source] with aggressive downsizing to prevent
  /// OOM on low-RAM devices (Samsung A13 = 3 GB).
  Future<void> _pickFromSource(ImageSource source, AddMedicineCubit cubit) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked != null) cubit.updateImagePath(picked.path);
    } catch (_) {
      // Camera or gallery was cancelled / unavailable — safe to ignore.
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddMedicineCubit, AddMedicineState>(
      listener: (context, state) {
        if (state is AddMedicineValidated && state.stepNumber == 1) {
          context.push('/medicines/add/2');
        }
      },
      builder: (context, state) {
        final currentData = state.formData;
        final colors = context.colors;
        final spacing = context.spacing;
        final typography = context.typography;

        return Scaffold(
          backgroundColor: colors.chatBackground,
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.xl, spacing.md, spacing.xl, spacing.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AddRecordNextButton(
                    onPressed: () {
                      context.read<AddMedicineCubit>().validateStep1();
                    },
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                CustomTopBar(onBack: () => context.pop()),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: spacing.xl),
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
                        _buildNameField(context, currentData, colors, typography),
                        if (currentData.validationErrors['medicineName'] !=
                            null) ...[
                          SizedBox(height: spacing.sm),
                          AnimatedSwitcher(
                            duration: context.durations.fast,
                            child: Text(
                              AppLocalizations.dynamicTr(
                                currentData.validationErrors['medicineName']!,
                              ),
                              key: ValueKey(
                                currentData.validationErrors['medicineName'],
                              ),
                              style: typography.label.copyWith(
                                color: colors.error,
                              ),
                            ),
                          ),
                        ],
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
      },
    );
  }

  Widget _buildNameField(
    BuildContext context,
    dynamic currentData,
    dynamic colors,
    dynamic typography,
  ) {
    return TextField(
      onChanged: (v) {
        context.read<AddMedicineCubit>().updateMedicineName(v);
      },
      decoration: InputDecoration(
        hintText: AppLocalizations.medicinesMedicineNameHint,
        suffixIcon: IconButton(
          icon: currentData.imagePath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(context.radius.sm),
                  child: Image.file(
                    File(currentData.imagePath!),
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(Icons.photo_camera, color: colors.primary),
          onPressed: () => _pickImage(context),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.radius.md),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.radius.md),
          borderSide: BorderSide(color: colors.primary),
        ),
      ),
    );
  }
}

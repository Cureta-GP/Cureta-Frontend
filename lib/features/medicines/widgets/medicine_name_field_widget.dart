import 'dart:io';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state.dart';
import 'package:image_picker/image_picker.dart';
/// Bottom sheet that lets the user pick an image from camera or gallery.
class ImagePickerSheetWidget extends StatelessWidget {
  const ImagePickerSheetWidget({super.key, required this.cubit});

  final AddMedicineCubit cubit;

  static Future<void> show(BuildContext context) async {
    final cubit = context.read<AddMedicineCubit>();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.radius.xl),
        ),
      ),
      builder: (_) => ImagePickerSheetWidget(cubit: cubit),
    );
  }

  Future<void> _pickFromSource(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked != null) cubit.updateImagePath(picked.path);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;

    return SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.all(spacing.lg),
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
                Navigator.pop(context);
                _pickFromSource(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: colors.primary),
              title: Text(
                AppLocalizations.medicinesPickFromGallery,
                style: typography.body.copyWith(color: colors.textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickFromSource(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Name text field with image picker suffix icon.
/// Only rebuilds when [imagePath] changes.
class MedicineNameFieldWidget extends StatelessWidget {
  const MedicineNameFieldWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radius;
    final spacing = context.spacing;
    final typography = context.typography;
    return BlocSelector<AddMedicineCubit, AddMedicineState, String?>(
      selector: (state) => state.formData.imagePath,
      builder: (context, imagePath) {
        return TextField(
          onChanged: (v) => context.read<AddMedicineCubit>().updateMedicineName(v),
          style: typography.medicalRecordInput.copyWith(
            color: colors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: AppLocalizations.medicinesMedicineNameHint,
            hintStyle: typography.medicalRecordInput.copyWith(
              color: colors.textHint,
            ),
            filled: true,
            fillColor: colors.background,
            contentPadding: EdgeInsets.symmetric(
              horizontal: spacing.xl,
              vertical: spacing.md,
            ),
            suffixIcon: IconButton(
              icon: imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(radius.sm),
                      child: Image.file(
                        File(imagePath),
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(Icons.photo_camera, color: colors.primary),
              onPressed: () => ImagePickerSheetWidget.show(context),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius.full),
              borderSide: BorderSide(color: colors.divider, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius.full),
              borderSide: BorderSide(color: colors.primary, width: 1.6),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius.full),
              borderSide: BorderSide(color: colors.error, width: 1.6),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius.full),
              borderSide: BorderSide(color: colors.error, width: 1.6),
            ),
          ),
        );
      },
    );
  }
}

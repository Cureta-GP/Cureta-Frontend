import 'dart:io';

import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/widgets/record_details_editable_field.dart';
import 'package:cureta/features/medicines/widgets/add_alarm_time_button_widget.dart';
import 'package:cureta/features/medicines/widgets/time_picker_row_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MedicineDetailsEditFormWidget extends StatelessWidget {
  const MedicineDetailsEditFormWidget({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.doseAmountController,
    required this.doseUnitController,
    required this.notesController,
    required this.alarmTimesNotifier,
    required this.imagePathNotifier,
    required this.onSave,
    required this.onCancel,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController doseAmountController;
  final TextEditingController doseUnitController;
  final TextEditingController notesController;
  final ValueNotifier<List<String>> alarmTimesNotifier;
  final ValueNotifier<String?> imagePathNotifier;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ValueListenableBuilder<String?>(
              valueListenable: imagePathNotifier,
              builder: (context, imagePath, _) {
                return Center(
                  child: GestureDetector(
                    onTap: () => _showImagePickerSheet(context),
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: colors.surface,
                      backgroundImage: (imagePath != null && imagePath.isNotEmpty)
                          ? FileImage(File(imagePath))
                          : null,
                      child: (imagePath == null || imagePath.isEmpty)
                          ? Icon(Icons.photo_camera, color: colors.primary, size: 28)
                          : null,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: spacing.sm),
            Center(
              child: TextButton.icon(
                onPressed: () => _showImagePickerSheet(context),
                icon: Icon(Icons.edit, color: colors.primary),
                label: Text(
                  AppLocalizations.medicinesPickImageTitle,
                  style: TextStyle(color: colors.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: spacing.md),
            RecordDetailsEditableField(
              controller: nameController,
              label: 'medicines.medicine_name_label'.tr(),
            ),
            SizedBox(height: spacing.md),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: RecordDetailsEditableField(
                    controller: doseAmountController,
                    label: 'medicines.dose_amount_hint'.tr(),
                  ),
                ),
                SizedBox(width: spacing.md),
                Expanded(
                  flex: 1,
                  child: RecordDetailsEditableField(
                    controller: doseUnitController,
                    label: 'medicines.dose_unit_hint'.tr(),
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.md),
            RecordDetailsEditableField(
              controller: notesController,
              label: 'medicines.details_notes_label'.tr(),
              minLines: 3,
              maxLines: 5,
            ),
            SizedBox(height: spacing.xl),
            Text(
              'medicines.alarm_times_label'.tr(),
              style: typography.medicalRecordDetailLabel.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: spacing.sm),
            ValueListenableBuilder<List<String>>(
              valueListenable: alarmTimesNotifier,
              builder: (context, alarmTimes, _) {
                return Column(
                  children: [
                    ...List.generate(alarmTimes.length, (i) {
                      return Padding(
                        padding: EdgeInsetsDirectional.only(bottom: spacing.sm),
                        child: TimePickerRowWidget(
                          time: alarmTimes[i],
                          canRemove: true,
                          onTap: () async {
                            final parts = alarmTimes[i].split(':');
                            final initial = TimeOfDay(
                              hour: int.tryParse(parts[0]) ?? 8,
                              minute: parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0,
                            );
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: initial,
                            );
                            if (picked == null) return;
                            final updated = List<String>.from(alarmTimes);
                            updated[i] = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                            alarmTimesNotifier.value = updated;
                          },
                          onRemove: () {
                            final updated = List<String>.from(alarmTimes)..removeAt(i);
                            alarmTimesNotifier.value = updated;
                          },
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
            AddAlarmTimeButtonWidget(
              initialTime: const TimeOfDay(hour: 8, minute: 0),
              onTimePicked: (picked) {
                final updated = List<String>.from(alarmTimesNotifier.value)
                  ..add('${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}');
                alarmTimesNotifier.value = updated;
              },
            ),
            SizedBox(height: spacing.xl),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.background,
                padding: EdgeInsets.symmetric(vertical: spacing.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.radius.full)),
              ),
              onPressed: onSave,
              child: Text(
                AppLocalizations.medicinesSaveChanges,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(height: spacing.sm),
            TextButton(
              onPressed: onCancel,
              child: Text(
                AppLocalizations.medicinesCancel,
                style: TextStyle(color: colors.textSecondary, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showImagePickerSheet(BuildContext context) async {
    final colors = context.colors;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: colors.primary),
              title: Text(AppLocalizations.medicinesPickFromCamera),
              onTap: () async {
                Navigator.pop(context);
                await _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: colors.primary),
              title: Text(AppLocalizations.medicinesPickFromGallery),
              onTap: () async {
                Navigator.pop(context);
                await _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (picked != null) {
      imagePathNotifier.value = picked.path;
    }
  }
}

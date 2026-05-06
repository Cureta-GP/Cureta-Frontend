import 'dart:io';

import 'package:cureta/shared/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medicines/veiw_model/medicine_details_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/medicine_details_state.dart';
import 'package:cureta/features/medicines/widgets/medicine_details_grid_widget.dart';
import 'package:cureta/features/medicines/widgets/medicine_info_card_widget.dart';
import 'package:cureta/features/medicines/widgets/medicine_logs_list_widget.dart';
import 'package:cureta/features/medicines/widgets/medicine_list_error_widget.dart';
import 'package:cureta/features/medicines/data/models/medicine_model.dart';
import 'package:cureta/features/medicines/data/models/dose_log_model.dart';

import 'package:cureta/features/medicines/widgets/medicine_details_overlay.dart';
import 'package:cureta/features/medicines/widgets/medicine_delete_confirm_dialog.dart';
import 'package:cureta/core/error_handling/error_handler.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cureta/features/medical_records/widgets/record_details_editable_field.dart';
import 'package:cureta/features/medicines/widgets/time_picker_row_widget.dart';

class MedicineDetailsVeiw extends StatefulWidget {
  const MedicineDetailsVeiw({super.key, required this.onEditTap});
  final VoidCallback onEditTap;

  @override
  State<MedicineDetailsVeiw> createState() => _MedicineDetailsVeiwState();
}

class _MedicineDetailsVeiwState extends State<MedicineDetailsVeiw> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _doseAmountController = TextEditingController();
  final _doseUnitController = TextEditingController();
  final _notesController = TextEditingController();
  List<String> _alarmTimes = [];
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  late final _MedicineDetailsLifecycleObserver _lifecycleObserver =
      _MedicineDetailsLifecycleObserver(
        onResumed: () {
          if (!mounted) return;
          final state = context.read<MedicineDetailsCubit>().state;
          final isEditing = state is MedicineDetailsLoaded && state.isEditing;
          if (!isEditing) {
            context.read<MedicineDetailsCubit>().loadDetails();
          }
        },
      );

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    _nameController.dispose();
    _doseAmountController.dispose();
    _doseUnitController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _syncControllers(MedicineModel medicine) {
    _nameController.text = medicine.name;
    _doseAmountController.text = medicine.doseAmount;
    _doseUnitController.text = medicine.doseUnit;
    _notesController.text = medicine.notes ?? '';
    _alarmTimes = List<String>.from(medicine.alarmTimes);
    _imagePath = medicine.imagePath;
  }

  Future<void> _handleSave(BuildContext context, MedicineDetailsCubit cubit) async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await cubit.saveChanges(
        name: _nameController.text.trim(),
        doseAmount: _doseAmountController.text.trim(),
        doseUnit: _doseUnitController.text.trim(),
        notes: _notesController.text.trim(),
        alarmTimes: _alarmTimes,
        imagePath: _imagePath,
      );
    } catch (e) {
      if (mounted) ErrorHandler.show(context, AppException.server(msg: 'Failed to update'));
    }
  }

  Future<void> _handleDelete(BuildContext context, MedicineDetailsCubit cubit) async {
    final state = cubit.state;
    final medicineName = state is MedicineDetailsLoaded ? state.medicine.name : '';
    final confirmed = await showMedicineDeleteConfirmationDialog(
      context,
      medicineName: medicineName,
    );
    if (confirmed != true) return;
    try {
      await cubit.deleteMedicine();
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) ErrorHandler.show(context, AppException.server(msg: AppLocalizations.recordDetailsDeleteFailed));
    }
  }

  Widget _buildShimmerLoading(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    return Shimmer.fromColors(
      baseColor: colors.divider,
      highlightColor: colors.surface,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          children: [
            Container(height: 120, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(radius.lg))),
            SizedBox(height: spacing.lg),
            Container(height: 150, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(radius.lg))),
            SizedBox(height: spacing.lg),
            Container(height: 200, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(radius.lg))),
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm(BuildContext context, MedicineModel medicine, MedicineDetailsCubit cubit) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: GestureDetector(
                onTap: () => _showImagePickerSheet(context),
                child: CircleAvatar(
                  radius: 38,
                  backgroundColor: colors.surface,
                  backgroundImage: (_imagePath != null && _imagePath!.isNotEmpty)
                      ? FileImage(File(_imagePath!))
                      : null,
                  child: (_imagePath == null || _imagePath!.isEmpty)
                      ? Icon(Icons.photo_camera, color: colors.primary, size: 28)
                      : null,
                ),
              ),
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
              controller: _nameController,
              label: 'medicines.medicine_name_label'.tr(),
            ),
            SizedBox(height: spacing.md),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: RecordDetailsEditableField(
                    controller: _doseAmountController,
                    label: 'medicines.dose_amount_hint'.tr(),
                  ),
                ),
                SizedBox(width: spacing.md),
                Expanded(
                  flex: 1,
                  child: RecordDetailsEditableField(
                    controller: _doseUnitController,
                    label: 'medicines.dose_unit_hint'.tr(),
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.md),
            RecordDetailsEditableField(
              controller: _notesController,
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
            ...List.generate(_alarmTimes.length, (i) {
              return Padding(
                padding: EdgeInsetsDirectional.only(bottom: spacing.sm),
                child: TimePickerRowWidget(
                  time: _alarmTimes[i],
                  canRemove: true,
                  onTap: () async {
                    final parts = _alarmTimes[i].split(':');
                    final initial = TimeOfDay(
                      hour: int.tryParse(parts[0]) ?? 8,
                      minute: parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0,
                    );
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: initial,
                    );
                    if (picked != null && mounted) {
                      setState(() {
                        _alarmTimes[i] = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                      });
                    }
                  },
                  onRemove: () {
                    setState(() {
                      _alarmTimes.removeAt(i);
                    });
                  },
                ),
              );
            }),
            TextButton.icon(
              icon: Icon(Icons.add_alarm, color: colors.primary),
              label: Text('medicines.add_alarm_time'.tr(), style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold)),
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 8, minute: 0),
                );
                if (picked != null && mounted) {
                  setState(() {
                    _alarmTimes.add('${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}');
                  });
                }
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
              onPressed: () => _handleSave(context, cubit),
              child: Text(AppLocalizations.medicinesSaveChanges, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            SizedBox(height: spacing.sm),
            TextButton(
              onPressed: () => cubit.cancelEdit(),
              child: Text(AppLocalizations.medicinesCancel, style: TextStyle(color: colors.textSecondary, fontSize: 16, fontWeight: FontWeight.bold)),
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
    if (picked != null && mounted) {
      setState(() {
        _imagePath = picked.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;
    return BlocConsumer<MedicineDetailsCubit, MedicineDetailsState>(
      listenWhen: (prev, curr) {
        if (prev is MedicineDetailsLoaded && curr is MedicineDetailsLoaded) {
          return !prev.isEditing && curr.isEditing;
        }
        return false;
      },
      listener: (context, state) {
        if (state is MedicineDetailsLoaded && state.isEditing) {
          _syncControllers(state.medicine);
        }
      },
      builder: (context, state) {
        final cubit = context.read<MedicineDetailsCubit>();
        final isEditing = state is MedicineDetailsLoaded && state.isEditing;
        final title = state is MedicineDetailsLoaded ? state.medicine.name : '';

        return Scaffold(
          backgroundColor: colors.background,
          appBar: AppBar(
            backgroundColor: colors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colors.textPrimary),
              onPressed: () {
                if (isEditing) {
                  cubit.cancelEdit();
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
            centerTitle: true,
            title: Text(
              isEditing ? AppLocalizations.medicinesEditMedicine : title,
              style: typography.medicalRecordScreenTitle.copyWith(color: colors.textPrimary),
            ),
          ),
          body: Stack(
            children: [
              if (state is MedicineDetailsLoading || state is MedicineDetailsInitial)
                _buildShimmerLoading(context)
              else if (state is MedicineDetailsError)
                MedicineListErrorWidget(
                  messageKey: state.messageKey,
                  onRetry: () => cubit.loadDetails(),
                )
              else if (state is MedicineDetailsLoaded)
                isEditing
                    ? _buildEditForm(context, state.medicine, cubit)
                    : SingleChildScrollView(
                        padding: EdgeInsetsDirectional.only(start: spacing.xl, end: spacing.xl, top: spacing.lg, bottom: spacing.xxl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MedicineInfoCardWidget(medicine: state.medicine),
                            SizedBox(height: spacing.lg),
                            MedicineDetailsGridWidget(
                              medicine: state.medicine,
                              onToggleActive: (value) => cubit.toggleActive(value),
                            ),
                            SizedBox(height: spacing.lg),
                            MedicineLogsListWidget(logs: state.logs),
                            SizedBox(height: spacing.xl * 1.5),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: colors.primary,
                                      side: BorderSide(color: colors.primary, width: 2),
                                      padding: EdgeInsets.symmetric(vertical: spacing.md),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.radius.lg)),
                                    ),
                                    icon: const Icon(Icons.edit, size: 22),
                                    label: Text(AppLocalizations.medicinesEditMedicine, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    onPressed: () => cubit.startEdit(),
                                  ),
                                ),
                                SizedBox(width: spacing.md),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.error,
                                      foregroundColor: colors.background,
                                      padding: EdgeInsets.symmetric(vertical: spacing.md),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.radius.lg)),
                                    ),
                                    icon: const Icon(Icons.delete_forever_rounded, size: 22),
                                    label: Text(AppLocalizations.medicinesDeleteMedicine, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    onPressed: () => _handleDelete(context, cubit),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              if (state is MedicineDetailsLoaded)
                MedicineDetailsOverlay(mode: state.busyMode),
            ],
          ),
        );
      },
    );
  }
}

class _MedicineDetailsLifecycleObserver with WidgetsBindingObserver {
  _MedicineDetailsLifecycleObserver({required this.onResumed});

  final VoidCallback onResumed;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    }
  }
}

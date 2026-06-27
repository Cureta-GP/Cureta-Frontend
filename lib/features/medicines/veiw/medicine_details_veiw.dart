import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medicines/veiw_model/medicine_details_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/medicine_details_state.dart';
import 'package:cureta/features/medicines/widgets/medicine_details_grid_widget.dart';
import 'package:cureta/features/medicines/widgets/medicine_details_edit_form_widget.dart';
import 'package:cureta/features/medicines/widgets/medicine_info_card_widget.dart';
import 'package:cureta/features/medicines/widgets/medicine_logs_list_widget.dart';
import 'package:cureta/features/medicines/widgets/medicine_list_error_widget.dart';
import 'package:cureta/features/medicines/data/models/medicine_model.dart';
import 'package:cureta/features/medicines/data/models/medicine_enums.dart';
import 'package:cureta/features/medicines/widgets/medicine_details_overlay.dart';
import 'package:cureta/features/medicines/widgets/medicine_delete_confirm_dialog.dart';
import 'package:cureta/core/error_handling/error_handler.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

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
  final ValueNotifier<List<String>> _alarmTimesNotifier = ValueNotifier<List<String>>([]);
  final ValueNotifier<Frequency> _frequencyNotifier = ValueNotifier<Frequency>(Frequency.daily);
  final ValueNotifier<String?> _imagePathNotifier = ValueNotifier<String?>(null);

  @override
  void dispose() {
    _nameController.dispose();
    _doseAmountController.dispose();
    _doseUnitController.dispose();
    _notesController.dispose();
    _alarmTimesNotifier.dispose();
    _frequencyNotifier.dispose();
    _imagePathNotifier.dispose();
    super.dispose();
  }

  void _syncControllers(MedicineModel medicine) {
    _nameController.text = medicine.name;
    _doseAmountController.text = medicine.doseAmount;
    _doseUnitController.text = medicine.doseUnit;
    _notesController.text = medicine.notes ?? '';
    _alarmTimesNotifier.value = List<String>.from(medicine.alarmTimes);
    _frequencyNotifier.value = medicine.frequency;
    _imagePathNotifier.value = medicine.imagePath;
  }

  Future<void> _handleSave(BuildContext context, MedicineDetailsCubit cubit) async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await cubit.saveChanges(
        name: _nameController.text.trim(),
        doseAmount: _doseAmountController.text.trim(),
        doseUnit: _doseUnitController.text.trim(),
        notes: _notesController.text.trim(),
        alarmTimes: _alarmTimesNotifier.value,
        frequency: _frequencyNotifier.value,
        imagePath: _imagePathNotifier.value,
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
                    ? MedicineDetailsEditFormWidget(
                        formKey: _formKey,
                        nameController: _nameController,
                        doseAmountController: _doseAmountController,
                        doseUnitController: _doseUnitController,
                        notesController: _notesController,
                        alarmTimesNotifier: _alarmTimesNotifier,
                        frequencyNotifier: _frequencyNotifier,
                        imagePathNotifier: _imagePathNotifier,
                        onSave: () => _handleSave(context, cubit),
                        onCancel: cubit.cancelEdit,
                      )
                    : SingleChildScrollView(
                        padding: EdgeInsetsDirectional.only(start: spacing.md, end: spacing.md, top: spacing.lg, bottom: spacing.xxl),
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
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: colors.primary,
                                      side: BorderSide(color: colors.primary, width: 2),
                                      padding: EdgeInsets.symmetric(horizontal: spacing.xs, vertical: spacing.md),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.radius.lg)),
                                    ),
                                    onPressed: () => cubit.startEdit(),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.edit, size: 20),
                                        SizedBox(width: spacing.xs),
                                        Flexible(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              AppLocalizations.medicinesEditMedicine,
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: spacing.sm),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.error,
                                      foregroundColor: colors.background,
                                      padding: EdgeInsets.symmetric(horizontal: spacing.xs, vertical: spacing.md),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.radius.lg)),
                                    ),
                                    onPressed: () => _handleDelete(context, cubit),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.delete_forever_rounded, size: 20),
                                        SizedBox(width: spacing.xs),
                                        Flexible(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              AppLocalizations.medicinesDeleteMedicine,
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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

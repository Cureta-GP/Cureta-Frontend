import 'package:cureta/features/medical_records/data/models/medical_record_model.dart';
import 'package:cureta/features/medical_records/veiw/record_details_callbacks.dart';
import 'package:cureta/features/medical_records/veiw/record_details_delete_action.dart';
import 'package:cureta/features/medical_records/veiw/record_details_save_action.dart';
import 'package:cureta/features/medical_records/veiw_model/record_details_cubit.dart';
import 'package:cureta/features/medical_records/widgets/record_details_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordDetailsCoordinator extends StatefulWidget {
  const RecordDetailsCoordinator({
    super.key,
    this.record,
    required this.conditionName,
    required this.isOngoing,
    required this.diagnosedDate,
    required this.notes,
    this.onEdit,
    this.onDelete,
    this.onFileTap,
  });

  final MedicalRecordModel? record;
  final String conditionName;
  final bool isOngoing;
  final String diagnosedDate;
  final String notes;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<int>? onFileTap;

  @override
  State<RecordDetailsCoordinator> createState() =>
      _RecordDetailsCoordinatorState();
}

class _RecordDetailsCoordinatorState extends State<RecordDetailsCoordinator> {
  late final RecordDetailsCubit _detailsCubit;
  late final TextEditingController _conditionController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _detailsCubit = RecordDetailsCubit(initialRecord: widget.record);
    _conditionController = TextEditingController(
      text: widget.record?.diseaseName ?? widget.conditionName,
    );
    _notesController = TextEditingController(
      text: widget.record?.notes ?? widget.notes,
    );
  }

  @override
  void dispose() {
    _conditionController.dispose();
    _notesController.dispose();
    _detailsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecordDetailsCubit>.value(
      value: _detailsCubit,
      child: RecordDetailsScaffold(
        record: widget.record,
        conditionName: widget.conditionName,
        isOngoing: widget.isOngoing,
        diagnosedDate: widget.diagnosedDate,
        notes: widget.notes,
        conditionController: _conditionController,
        notesController: _notesController,
        onPickDate: () =>
            pickRecordDate(context: context, detailsCubit: _detailsCubit),
        onToggleAttachment: _detailsCubit.toggleAttachmentRemoval,
        onFileTap: (i) => handleRecordFileTap(
          context: context,
          detailsCubit: _detailsCubit,
          index: i,
          externalFileTap: widget.onFileTap,
          onError: (message) => showRecordDetailsMessage(context, message),
        ),
        onEdit:
            widget.onEdit ??
            () {
              _detailsCubit.startEdit();
              syncRecordControllers(
                state: _detailsCubit.state,
                fallbackCondition: widget.conditionName,
                fallbackNotes: widget.notes,
                conditionController: _conditionController,
                notesController: _notesController,
              );
            },
        onSave: () => runRecordSaveAction(
          context: context,
          detailsCubit: _detailsCubit,
          recordsCubit: readRecordListCubit(context),
          conditionController: _conditionController,
          notesController: _notesController,
          syncControllers: () => syncRecordControllers(
            state: _detailsCubit.state,
            fallbackCondition: widget.conditionName,
            fallbackNotes: widget.notes,
            conditionController: _conditionController,
            notesController: _notesController,
          ),
          showMessage: (message) => showRecordDetailsMessage(context, message),
          isMounted: () => mounted,
        ),
        onCancel: () {
          _detailsCubit.cancelEdit();
          syncRecordControllers(
            state: _detailsCubit.state,
            fallbackCondition: widget.conditionName,
            fallbackNotes: widget.notes,
            conditionController: _conditionController,
            notesController: _notesController,
          );
        },
        onDelete:
            widget.onDelete ??
            () => runRecordDeleteAction(
              context: context,
              detailsCubit: _detailsCubit,
              recordsCubit: readRecordListCubit(context),
              showMessage: (message) =>
                  showRecordDetailsMessage(context, message),
              isMounted: () => mounted,
              onDeleted: () => Navigator.of(context).pop(true),
            ),
      ),
    );
  }
}

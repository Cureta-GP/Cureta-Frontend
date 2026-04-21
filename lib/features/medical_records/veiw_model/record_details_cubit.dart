import 'package:bloc/bloc.dart';
import 'package:cureta/features/medical_records/data/models/medical_record_model.dart';
import 'package:cureta/features/medical_records/veiw_model/medical_records_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/record_details_state.dart';

class RecordDetailsCubit extends Cubit<RecordDetailsState> {
  RecordDetailsCubit({required MedicalRecordModel? initialRecord})
    : super(
        RecordDetailsState(
          record: initialRecord,
          isEditing: false,
          busyMode: RecordBusyMode.none,
          editedDate: DateTime.tryParse(initialRecord?.recordDate ?? ''),
          removeAttachmentIds: const [],
        ),
      );

  void startEdit() {
    emit(
      state.copyWith(
        isEditing: true,
        editedDate: DateTime.tryParse(state.record?.recordDate ?? ''),
        removeAttachmentIds: const [],
      ),
    );
  }

  void cancelEdit() {
    emit(
      state.copyWith(
        isEditing: false,
        editedDate: DateTime.tryParse(state.record?.recordDate ?? ''),
        removeAttachmentIds: const [],
      ),
    );
  }

  void setBusyMode(RecordBusyMode mode) {
    emit(state.copyWith(busyMode: mode));
  }

  void setDate(DateTime date) {
    emit(state.copyWith(editedDate: date));
  }

  void toggleAttachmentRemoval(String attachmentId) {
    final updated = List<String>.from(state.removeAttachmentIds);
    if (updated.contains(attachmentId)) {
      updated.remove(attachmentId);
    } else {
      updated.add(attachmentId);
    }

    emit(state.copyWith(removeAttachmentIds: updated));
  }

  void applyUpdatedRecord(MedicalRecordModel updated) {
    emit(
      state.copyWith(
        record: updated,
        isEditing: false,
        busyMode: RecordBusyMode.none,
        editedDate: DateTime.tryParse(updated.recordDate),
        removeAttachmentIds: const [],
      ),
    );
  }

  Future<MedicalRecordModel> saveChanges({
    required MedicalRecordsCubit recordsCubit,
    required String diseaseName,
    required String? notes,
  }) async {
    final rec = state.record;
    if (rec == null) {
      throw StateError('Record is null');
    }

    setBusyMode(RecordBusyMode.saving);
    final updated = await recordsCubit.updateRecord(
      recordId: rec.id,
      diseaseName: diseaseName,
      notes: notes,
      recordDate: state.editedDate ?? DateTime.now(),
      removeAttachmentIds: state.removeAttachmentIds,
    );

    applyUpdatedRecord(updated);
    return updated;
  }

  Future<void> deleteCurrent({
    required MedicalRecordsCubit recordsCubit,
  }) async {
    final rec = state.record;
    if (rec == null) {
      throw StateError('Record is null');
    }

    setBusyMode(RecordBusyMode.deleting);
    await recordsCubit.deleteRecord(recordId: rec.id);
  }
}

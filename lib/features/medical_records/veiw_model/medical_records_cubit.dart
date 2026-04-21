import 'package:bloc/bloc.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/features/medical_records/data/models/medical_record_model.dart';
import '../data/repo/medical_record_repository.dart';
import 'medical_records_state.dart';

class MedicalRecordsCubit extends Cubit<MedicalRecordsState> {
  MedicalRecordsCubit()
    : _repository = getIt.get<MedicalRecordRepository>(),
      super(const MedicalRecordsInitial());

  final MedicalRecordRepository _repository;

  /// Fetch records for the given profile.
  /// [forceRefresh] = true bypasses session cache (used by pull-to-refresh).
  Future<void> fetchRecords({
    required String profileId,
    String? type,
    String? search,
    bool forceRefresh = false,
  }) async {
    emit(MedicalRecordsLoading(isRefresh: forceRefresh));

    try {
      final records = await _repository.getRecords(
        profileId: profileId,
        type: type,
        search: search,
        forceRefresh: forceRefresh,
      );
      emit(MedicalRecordsSuccess(records));
    } on AppException catch (e) {
      emit(MedicalRecordsFailure(e));
    } catch (_) {
      emit(
        MedicalRecordsFailure(
          AppException.server(msg: 'Failed to load records'),
        ),
      );
    }
  }

  void reset() {
    emit(const MedicalRecordsInitial());
  }

  Future<void> deleteRecord({required String recordId}) async {
    await _repository.deleteRecord(id: recordId);
    if (state is MedicalRecordsSuccess) {
      final current = (state as MedicalRecordsSuccess).records;
      final updated = current.where((record) => record.id != recordId).toList();
      emit(MedicalRecordsSuccess(updated));
    }
  }

  Future<MedicalRecordModel> updateRecord({
    required String recordId,
    required String diseaseName,
    String? notes,
    required DateTime recordDate,
    List<String> removeAttachmentIds = const [],
  }) async {
    final date =
        '${recordDate.year}-${recordDate.month.toString().padLeft(2, '0')}-${recordDate.day.toString().padLeft(2, '0')}';

    final updatedRecord = await _repository.updateRecord(
      id: recordId,
      diseaseName: diseaseName,
      notes: notes,
      recordDate: date,
      removeAttachmentIds: removeAttachmentIds,
    );

    if (state is MedicalRecordsSuccess) {
      final current = (state as MedicalRecordsSuccess).records;
      final updated = current
          .map((record) => record.id == recordId ? updatedRecord : record)
          .toList();
      emit(MedicalRecordsSuccess(updated));
    }

    return updatedRecord;
  }
}

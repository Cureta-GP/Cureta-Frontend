import 'package:bloc/bloc.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:cureta/core/Services/GetItServices.dart';
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
}

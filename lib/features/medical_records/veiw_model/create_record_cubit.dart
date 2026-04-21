import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_step_four_state.dart';
import 'package:cureta/features/medical_records/data/repo/medical_record_repository.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'create_record_state.dart';

class CreateRecordCubit extends Cubit<CreateRecordState> {
  CreateRecordCubit()
    : _repository = getIt.get<MedicalRecordRepository>(),
      _profileRepository = getIt.get<ProfileRepository>(),
      super(const CreateRecordInitial());

  final MedicalRecordRepository _repository;
  final ProfileRepository _profileRepository;

  /// Submit the full medical record.
  ///
  /// [stepFourState] — the state from AddRecordStepFourCubit containing the uploaded files.
  Future<void> submit({
    String? profileId,
    required String diseaseName,
    String? notes,
    required DateTime recordDate,
    required AddRecordStepFourState stepFourState,
  }) async {
    // ── Guard: prevent double-tap ──
    if (state is CreateRecordLoading) return;
    emit(const CreateRecordLoading());
    try {
      // Flatten into ordered parallel lists
      final List<String> attachmentTypes = [];
      final List<String> filePaths = [];

      // Process prescription files
      for (final file in stepFourState.prescriptionFiles) {
        if (file.path == null || file.path!.isEmpty) continue;
        attachmentTypes.add('Prescription');
        filePaths.add(file.path!);
      }

      // Process lab test files
      for (final file in stepFourState.labTestFiles) {
        if (file.path == null || file.path!.isEmpty) continue;
        attachmentTypes.add('Lab_Test');
        filePaths.add(file.path!);
      }

      // Process scan files (X-ray)
      for (final file in stepFourState.scanFiles) {
        if (file.path == null || file.path!.isEmpty) continue;
        attachmentTypes.add('X-ray');
        filePaths.add(file.path!);
      }

      // Process report files
      for (final file in stepFourState.reportFiles) {
        if (file.path == null || file.path!.isEmpty) continue;
        attachmentTypes.add('Report');
        filePaths.add(file.path!);
      }

      // Process other files
      for (final file in stepFourState.otherFiles) {
        if (file.path == null || file.path!.isEmpty) continue;
        attachmentTypes.add('Other');
        filePaths.add(file.path!);
      }

      if (filePaths.isEmpty) {
        emit(
          CreateRecordFailure(
            AppException.validation(msg: 'Please attach at least one file'),
          ),
        );
        return;
      }

      final dateStr =
          '${recordDate.year}-${recordDate.month.toString().padLeft(2, '0')}-${recordDate.day.toString().padLeft(2, '0')}';

      final resolvedProfileId = (profileId != null && profileId.isNotEmpty)
          ? profileId
          : await _profileRepository.getResolvedSelectedProfileId();

      if (resolvedProfileId == null || resolvedProfileId.isEmpty) {
        emit(
          CreateRecordFailure(
            AppException.validation(msg: 'Profile not selected'),
          ),
        );
        return;
      }


      final record = await _repository.createRecord(
        profileId: resolvedProfileId,
        diseaseName: diseaseName,
        notes: notes,
        recordDate: dateStr,
        attachmentTypes: attachmentTypes,
        filePaths: filePaths,
      );

      emit(CreateRecordSuccess(record));
    } on AppException catch (e) {
      emit(CreateRecordFailure(e));
    } catch (_) {
      emit(CreateRecordFailure(AppException.server()));
    }
  }

  /// Reset to initial so the user can retry or start fresh.
  void reset() => emit(const CreateRecordInitial());
}

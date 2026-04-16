import 'package:cureta/core/error_handling/app_exceptions.dart';
import '../data/models/medical_record_model.dart';

sealed class CreateRecordState {
  const CreateRecordState();
}

/// Initial idle state — nothing has happened yet.
final class CreateRecordInitial extends CreateRecordState {
  const CreateRecordInitial();
}

/// API call in progress.
final class CreateRecordLoading extends CreateRecordState {
  const CreateRecordLoading();
}

/// Record created successfully.
final class CreateRecordSuccess extends CreateRecordState {
  final MedicalRecordModel record;
  const CreateRecordSuccess(this.record);
}

/// Submission failed.
final class CreateRecordFailure extends CreateRecordState {
  final AppException error;
  const CreateRecordFailure(this.error);
}

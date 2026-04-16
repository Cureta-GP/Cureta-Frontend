import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:equatable/equatable.dart';
import '../data/models/medical_record_model.dart';

sealed class MedicalRecordsState extends Equatable {
  const MedicalRecordsState();
}

final class MedicalRecordsInitial extends MedicalRecordsState {
  const MedicalRecordsInitial();
  @override
  List<Object?> get props => [];
}

final class MedicalRecordsLoading extends MedicalRecordsState {
  final bool isRefresh; // true = pull-to-refresh (don't show full shimmer)
  const MedicalRecordsLoading({this.isRefresh = false});
  @override
  List<Object?> get props => [isRefresh];
}

final class MedicalRecordsSuccess extends MedicalRecordsState {
  final List<MedicalRecordModel> records;
  const MedicalRecordsSuccess(this.records);
  @override
  List<Object?> get props => [records];
}

final class MedicalRecordsFailure extends MedicalRecordsState {
  final AppException error;
  const MedicalRecordsFailure(this.error);
  @override
  List<Object?> get props => [error];
}

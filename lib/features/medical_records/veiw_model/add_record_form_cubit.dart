import 'package:flutter_bloc/flutter_bloc.dart';

/// Stores the medical record form data across all steps.
/// This allows the data from steps 1-3 to be available when submitting in step 5.
class AddRecordFormCubit extends Cubit<AddRecordFormState> {
  AddRecordFormCubit() : super(const AddRecordFormState());

  void setCondition(String condition) {
    emit(state.copyWith(diseaseName: condition));
  }

  void setProfileId(String profileId) {
    emit(state.copyWith(profileId: profileId));
  }

  void setRecordDate(DateTime recordDate) {
    emit(state.copyWith(recordDate: recordDate));
  }

  void setNotes(String notes) {
    emit(state.copyWith(notes: notes));
  }

  void reset() {
    emit(const AddRecordFormState());
  }
}

class AddRecordFormState {
  const AddRecordFormState({
    this.profileId,
    this.diseaseName,
    this.recordDate,
    this.notes,
  });

  final String? profileId;
  final String? diseaseName;
  final DateTime? recordDate;
  final String? notes;

  AddRecordFormState copyWith({
    String? profileId,
    String? diseaseName,
    DateTime? recordDate,
    String? notes,
  }) {
    return AddRecordFormState(
      profileId: profileId ?? this.profileId,
      diseaseName: diseaseName ?? this.diseaseName,
      recordDate: recordDate ?? this.recordDate,
      notes: notes ?? this.notes,
    );
  }

  bool get isComplete =>
      profileId != null &&
      diseaseName != null &&
      diseaseName!.isNotEmpty &&
      recordDate != null;
}

import 'package:equatable/equatable.dart';
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

  void setIsOngoing(bool isOngoing) {
    emit(state.copyWith(isOngoing: isOngoing));
  }

  void reset() {
    emit(const AddRecordFormState());
  }
}

class AddRecordFormState extends Equatable {
  const AddRecordFormState({
    this.profileId = 'af7ecd51-feb6-4754-a76e-a9bd28f48617', // Temporary for testing
    this.diseaseName,
    this.recordDate,
    this.notes,
    this.isOngoing = true,
  });

  final String? profileId;
  final String? diseaseName;
  final DateTime? recordDate;
  final String? notes;
  final bool isOngoing;

  AddRecordFormState copyWith({
    String? profileId,
    String? diseaseName,
    DateTime? recordDate,
    String? notes,
    bool? isOngoing,
  }) {
    return AddRecordFormState(
      profileId: profileId ?? this.profileId,
      diseaseName: diseaseName ?? this.diseaseName,
      recordDate: recordDate ?? this.recordDate,
      notes: notes ?? this.notes,
      isOngoing: isOngoing ?? this.isOngoing,
    );
  }

  bool get isComplete =>
      profileId != null &&
      diseaseName != null &&
      diseaseName!.isNotEmpty &&
      recordDate != null;

  @override
  List<Object?> get props => [
    profileId,
    diseaseName,
    recordDate,
    notes,
    isOngoing,
  ];
}

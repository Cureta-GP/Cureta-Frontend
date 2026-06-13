import 'package:cureta/features/medical_records/data/models/medical_record_model.dart';
import 'package:equatable/equatable.dart';

enum RecordBusyMode { none, saving, deleting }

extension RecordBusyModeX on RecordBusyMode {
  bool get isActive => this != RecordBusyMode.none;

  String? get lottiePath => switch (this) {
    RecordBusyMode.saving => 'assets/animations/Update Successfully.json',
    RecordBusyMode.deleting => 'assets/animations/Deleted Successfully.json',
    RecordBusyMode.none => null,
  };
}

class RecordDetailsState extends Equatable {
  const RecordDetailsState({
    required this.record,
    required this.isEditing,
    required this.busyMode,
    required this.editedDate,
    required this.removeAttachmentIds,
  });

  final MedicalRecordModel? record;
  final bool isEditing;
  final RecordBusyMode busyMode;
  final DateTime? editedDate;
  final List<String> removeAttachmentIds;

  bool get isBusy => busyMode.isActive;

  RecordDetailsState copyWith({
    MedicalRecordModel? record,
    bool? isEditing,
    RecordBusyMode? busyMode,
    DateTime? editedDate,
    bool clearEditedDate = false,
    List<String>? removeAttachmentIds,
  }) {
    return RecordDetailsState(
      record: record ?? this.record,
      isEditing: isEditing ?? this.isEditing,
      busyMode: busyMode ?? this.busyMode,
      editedDate: clearEditedDate ? null : (editedDate ?? this.editedDate),
      removeAttachmentIds: removeAttachmentIds ?? this.removeAttachmentIds,
    );
  }

  @override
  List<Object?> get props => [
    record,
    isEditing,
    busyMode,
    editedDate,
    removeAttachmentIds,
  ];
}

import 'package:cureta/features/medical_records/data/models/add_record_uploaded_file.dart';

class AddRecordStepFourState {
  const AddRecordStepFourState({
    this.prescriptionFiles = const <AddRecordUploadedFile>[],
    this.labTestFiles = const <AddRecordUploadedFile>[],
    this.scanFiles = const <AddRecordUploadedFile>[],
  });

  final List<AddRecordUploadedFile> prescriptionFiles;
  final List<AddRecordUploadedFile> labTestFiles;
  final List<AddRecordUploadedFile> scanFiles;

  AddRecordStepFourState copyWith({
    List<AddRecordUploadedFile>? prescriptionFiles,
    List<AddRecordUploadedFile>? labTestFiles,
    List<AddRecordUploadedFile>? scanFiles,
  }) {
    return AddRecordStepFourState(
      prescriptionFiles: prescriptionFiles ?? this.prescriptionFiles,
      labTestFiles: labTestFiles ?? this.labTestFiles,
      scanFiles: scanFiles ?? this.scanFiles,
    );
  }

  List<AddRecordUploadedFile> filesOf(AddRecordUploadCategory category) {
    switch (category) {
      case AddRecordUploadCategory.prescription:
        return prescriptionFiles;
      case AddRecordUploadCategory.labTest:
        return labTestFiles;
      case AddRecordUploadCategory.scan:
        return scanFiles;
    }
  }

  AddRecordStepFourState withCategoryFiles(
    AddRecordUploadCategory category,
    List<AddRecordUploadedFile> files,
  ) {
    switch (category) {
      case AddRecordUploadCategory.prescription:
        return copyWith(prescriptionFiles: files);
      case AddRecordUploadCategory.labTest:
        return copyWith(labTestFiles: files);
      case AddRecordUploadCategory.scan:
        return copyWith(scanFiles: files);
    }
  }
}

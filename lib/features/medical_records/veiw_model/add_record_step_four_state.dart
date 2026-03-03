import 'package:cureta/features/medical_records/data/models/add_record_uploaded_file.dart';

import 'package:equatable/equatable.dart';

class AddRecordStepFourState extends Equatable {
  const AddRecordStepFourState({
    this.prescriptionFiles = const <AddRecordUploadedFile>[],
    this.labTestFiles = const <AddRecordUploadedFile>[],
    this.scanFiles = const <AddRecordUploadedFile>[],
    this.reportFiles = const <AddRecordUploadedFile>[],
    this.otherFiles = const <AddRecordUploadedFile>[],
    this.fileOpenError,
  });

  final List<AddRecordUploadedFile> prescriptionFiles;
  final List<AddRecordUploadedFile> labTestFiles;
  final List<AddRecordUploadedFile> scanFiles;
  final List<AddRecordUploadedFile> reportFiles;
  final List<AddRecordUploadedFile> otherFiles;
  final String? fileOpenError;

  AddRecordStepFourState copyWith({
    List<AddRecordUploadedFile>? prescriptionFiles,
    List<AddRecordUploadedFile>? labTestFiles,
    List<AddRecordUploadedFile>? scanFiles,
    List<AddRecordUploadedFile>? reportFiles,
    List<AddRecordUploadedFile>? otherFiles,
    String? fileOpenError,
    bool clearError = false,
  }) {
    return AddRecordStepFourState(
      prescriptionFiles: prescriptionFiles ?? this.prescriptionFiles,
      labTestFiles: labTestFiles ?? this.labTestFiles,
      scanFiles: scanFiles ?? this.scanFiles,
      reportFiles: reportFiles ?? this.reportFiles,
      otherFiles: otherFiles ?? this.otherFiles,
      fileOpenError: clearError ? null : (fileOpenError ?? this.fileOpenError),
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
      case AddRecordUploadCategory.report:
        return reportFiles;
      case AddRecordUploadCategory.other:
        return otherFiles;
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
      case AddRecordUploadCategory.report:
        return copyWith(reportFiles: files);
      case AddRecordUploadCategory.other:
        return copyWith(otherFiles: files);
    }
  }

  @override
  List<Object?> get props => [
    prescriptionFiles,
    labTestFiles,
    scanFiles,
    reportFiles,
    otherFiles,
    fileOpenError,
  ];
}

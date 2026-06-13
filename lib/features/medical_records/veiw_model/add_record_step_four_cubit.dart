import 'package:bloc/bloc.dart';
import 'package:cureta/features/medical_records/data/models/add_record_uploaded_file.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_step_four_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';

class AddRecordStepFourCubit extends Cubit<AddRecordStepFourState> {
  AddRecordStepFourCubit() : super(const AddRecordStepFourState());
  static const List<String> allowedExtensions = [
    'pdf',
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];
  String _extensionFromFile(PlatformFile file) {
    final extension = file.extension;
    if (extension != null && extension.isNotEmpty) {
      return extension.toLowerCase();
    }
    final nameParts = file.name.split('.');
    if (nameParts.length > 1) {
      return nameParts.last.toLowerCase();
    }
    return '';
  }

  Future<void> pickRecordFile(AddRecordUploadCategory category) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    final pickedFiles = result.files
        .map(
          (file) => AddRecordUploadedFile(
            id: '${DateTime.now().microsecondsSinceEpoch}_${file.name}_${file.size}',
            name: file.name,
            extension: _extensionFromFile(file),
            sizeBytes: file.size,
            path: file.path,
          ),
        )
        .toList();

    final currentFiles = state.filesOf(category);
    emit(state.withCategoryFiles(category, [...currentFiles, ...pickedFiles]));
  }

  Future<void> viewFile(AddRecordUploadedFile file) async {
    if (file.path == null || file.path!.isEmpty) {
      emit(state.copyWith(fileOpenError: 'File path is missing or invalid.'));
      // Clear error immediately so next time it triggers listener even if same string
      emit(state.copyWith(clearError: true));
      return;
    }

    final result = await OpenFilex.open(file.path!);
    if (result.type != ResultType.done) {
      emit(
        state.copyWith(
          fileOpenError: 'Unable to open this file: ${result.message}',
        ),
      );
      emit(state.copyWith(clearError: true));
    }
  }

  void deleteFile(
    AddRecordUploadCategory category,
    AddRecordUploadedFile file,
  ) {
    final updatedFiles = state
        .filesOf(category)
        .where((item) => item.id != file.id)
        .toList();

    emit(state.withCategoryFiles(category, updatedFiles));
  }

  void reset() {
    emit(const AddRecordStepFourState());
  }
}

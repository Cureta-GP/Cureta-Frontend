import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/models/add_record_uploaded_file.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_step_four_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_step_four_state.dart';
import 'package:cureta/features/medical_records/widgets/add_record_uploaded_file_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddRecordUploadedFilesSection extends StatelessWidget {
  const AddRecordUploadedFilesSection({
    super.key,
    required this.category,
    this.onViewFile,
    this.onDeleteFile,
  });

  final AddRecordUploadCategory category;
  final void Function(
    AddRecordUploadCategory category,
    AddRecordUploadedFile file,
  )?
  onViewFile;
  final void Function(
    AddRecordUploadCategory category,
    AddRecordUploadedFile file,
  )?
  onDeleteFile;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return BlocSelector<
      AddRecordStepFourCubit,
      AddRecordStepFourState,
      List<AddRecordUploadedFile>
    >(
      selector: (state) => state.filesOf(category),
      builder: (context, files) {
        if (files.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            SizedBox(height: spacing.sm),
            ...files.map(
              (file) => Padding(
                padding: EdgeInsets.only(bottom: spacing.sm),
                child: AddRecordUploadedFileTile(
                  file: file,
                  onView: () => onViewFile?.call(category, file),
                  onDelete: () => onDeleteFile?.call(category, file),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

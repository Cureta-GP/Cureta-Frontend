import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/models/medical_record_model.dart';
import 'package:cureta/features/medical_records/veiw/record_details_utils.dart';
import 'package:cureta/features/medical_records/veiw_model/record_details_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/record_details_state.dart';
import 'package:cureta/features/medical_records/widgets/record_details_body.dart';
import 'package:cureta/features/medical_records/widgets/record_details_documents_section.dart';
import 'package:cureta/features/medical_records/widgets/record_details_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordDetailsScaffold extends StatelessWidget {
  const RecordDetailsScaffold({
    super.key,
    required this.record,
    required this.conditionName,
    required this.isOngoing,
    required this.diagnosedDate,
    required this.notes,
    required this.conditionController,
    required this.notesController,
    required this.onPickDate,
    required this.onToggleAttachment,
    required this.onFileTap,
    required this.onEdit,
    required this.onSave,
    required this.onCancel,
    required this.onDelete,
  });

  final MedicalRecordModel? record;
  final String conditionName;
  final bool isOngoing;
  final String diagnosedDate;
  final String notes;
  final TextEditingController conditionController;
  final TextEditingController notesController;
  final VoidCallback onPickDate;
  final ValueChanged<String> onToggleAttachment;
  final ValueChanged<int> onFileTap;
  final VoidCallback onEdit;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return BlocBuilder<RecordDetailsCubit, RecordDetailsState>(
      builder: (context, state) {
        final rec = state.record;
        final title = rec?.diseaseName ?? conditionName;
        final ongoing = rec != null ? rec.attachments.isNotEmpty : isOngoing;
        final date = rec != null
            ? formatRecordDate(rec.recordDate)
            : diagnosedDate;
        final note = rec?.notes ?? notes;
        final files = rec != null
            ? buildRecordFilesFromAttachments(context, rec.attachments)
            : <RecordFile>[];

        return Scaffold(
          backgroundColor: colors.background,
          appBar: AppBar(
            backgroundColor: colors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colors.textPrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            title: Text(
              AppLocalizations.recordDetailsTitle,
              style: typography.medicalRecordUploadCardTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          body: Stack(
            children: [
              RecordDetailsBody(
                isEditing: state.isEditing,
                isBusy: state.isBusy,
                conditionController: conditionController,
                notesController: notesController,
                selectedDate: state.editedDate,
                conditionName: title,
                isOngoing: ongoing,
                diagnosedDate: date,
                notes: note,
                files: files,
                attachments: rec?.attachments ?? const [],
                removeAttachmentIds: state.removeAttachmentIds.toSet(),
                onPickDate: onPickDate,
                onToggleAttachment: onToggleAttachment,
                onFileTap: onFileTap,
                onEdit: onEdit,
                onSave: onSave,
                onCancel: onCancel,
                onDelete: onDelete,
              ),
              RecordDetailsOverlay(mode: state.busyMode),
            ],
          ),
        );
      },
    );
  }
}

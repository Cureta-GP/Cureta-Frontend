import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/models/attachment_model.dart';
import 'package:cureta/features/medical_records/widgets/record_details_bottom_actions.dart';
import 'package:cureta/features/medical_records/widgets/record_details_diagnosed_date.dart';
import 'package:cureta/features/medical_records/widgets/record_details_documents_section.dart';
import 'package:cureta/features/medical_records/widgets/record_details_editable_attachments.dart';
import 'package:cureta/features/medical_records/widgets/record_details_editable_date_field.dart';
import 'package:cureta/features/medical_records/widgets/record_details_editable_field.dart';
import 'package:cureta/features/medical_records/widgets/record_details_header.dart';
import 'package:cureta/features/medical_records/widgets/record_details_notes_card.dart';
import 'package:flutter/material.dart';

/// Scrollable body of the record details screen.
///
/// Pure display widget — no state, no business logic.
/// Switches between view-mode and edit-mode widgets based on [isEditing].
class RecordDetailsBody extends StatelessWidget {
  const RecordDetailsBody({
    super.key,
    required this.isEditing,
    required this.isBusy,
    required this.conditionController,
    required this.notesController,
    required this.selectedDate,
    required this.conditionName,
    required this.isOngoing,
    required this.diagnosedDate,
    required this.notes,
    required this.files,
    required this.attachments,
    required this.removeAttachmentIds,
    required this.onPickDate,
    required this.onToggleAttachment,
    required this.onFileTap,
    required this.onEdit,
    required this.onSave,
    required this.onCancel,
    required this.onDelete,
  });

  // ── Mode flags ────────────────────────────────────────────────────────────

  final bool isEditing;
  final bool isBusy;

  // ── Edit-mode controllers ─────────────────────────────────────────────────

  final TextEditingController conditionController;
  final TextEditingController notesController;
  final DateTime? selectedDate;

  // ── Resolved display data ─────────────────────────────────────────────────

  final String conditionName;
  final bool isOngoing;
  final String diagnosedDate;
  final String notes;
  final List<RecordFile> files;
  final List<AttachmentModel> attachments;
  final Set<String> removeAttachmentIds;

  // ── Callbacks ─────────────────────────────────────────────────────────────

  final VoidCallback onPickDate;
  final ValueChanged<String> onToggleAttachment;
  final ValueChanged<int> onFileTap;
  final VoidCallback onEdit;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: spacing.xl),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: spacing.xs),

                // ── Condition name ──
                if (isEditing)
                  RecordDetailsEditableField(
                    label: AppLocalizations.addRecordReviewCondition,
                    controller: conditionController,
                  )
                else
                  RecordDetailsHeader(
                    conditionName: conditionName,
                    isOngoing: isOngoing,
                  ),
                SizedBox(height: spacing.xxl),

                // ── Diagnosed date ──
                if (isEditing)
                  RecordDetailsEditableDateField(
                    selectedDate: selectedDate ?? DateTime.now(),
                    isBusy: isBusy,
                    onTap: onPickDate,
                  )
                else
                  RecordDetailsDiagnosedDate(date: diagnosedDate),
                SizedBox(height: spacing.xxl),

                // ── Notes ──
                if (isEditing)
                  RecordDetailsEditableField(
                    label: AppLocalizations.recordDetailsNotesTitle,
                    controller: notesController,
                    minLines: 4,
                    maxLines: 6,
                  )
                else if (notes.isNotEmpty)
                  RecordDetailsNotesCard(notes: notes),
                SizedBox(height: spacing.xxl),

                // ── Attachments ──
                if (isEditing && attachments.isNotEmpty)
                  RecordDetailsEditableAttachments(
                    attachments: attachments,
                    removeAttachmentIds: removeAttachmentIds,
                    isBusy: isBusy,
                    onToggle: onToggleAttachment,
                  )
                else if (files.isNotEmpty)
                  RecordDetailsDocumentsSection(
                    files: files,
                    onFileTap: onFileTap,
                  ),

                // ── Action buttons ──
                RecordDetailsBottomActions(
                  isEditing: isEditing,
                  isBusy: isBusy,
                  onEdit: onEdit,
                  onSave: onSave,
                  onCancel: onCancel,
                  onDelete: onDelete,
                ),
                SizedBox(height: spacing.xl),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

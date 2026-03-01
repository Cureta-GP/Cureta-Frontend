import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/widgets/record_details_bottom_actions.dart';
import 'package:cureta/features/medical_records/widgets/record_details_diagnosed_date.dart';
import 'package:cureta/features/medical_records/widgets/record_details_documents_section.dart';
import 'package:cureta/features/medical_records/widgets/record_details_header.dart';
import 'package:cureta/features/medical_records/widgets/record_details_notes_card.dart';
import 'package:flutter/material.dart';

/// The main Record Details screen that assembles all micro-widgets.
///
/// Requires the record data to be passed via constructor:
/// [conditionName], [isOngoing], [diagnosedDate], [notes], and [files].
class RecordDetailsView extends StatelessWidget {
  const RecordDetailsView({
    super.key,
    required this.conditionName,
    required this.isOngoing,
    required this.diagnosedDate,
    required this.notes,
    required this.files,
    this.onEdit,
    this.onDelete,
    this.onViewAllFiles,
    this.onFileTap,
  });

  final String conditionName;
  final bool isOngoing;
  final String diagnosedDate;
  final String notes;
  final List<RecordFile> files;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onViewAllFiles;
  final ValueChanged<int>? onFileTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

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
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: colors.textPrimary),
            onPressed: () {
              // TODO: show options menu
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: spacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: spacing.xs),
              RecordDetailsHeader(
                conditionName: conditionName,
                isOngoing: isOngoing,
              ),
              SizedBox(height: spacing.xxl),
              RecordDetailsDiagnosedDate(date: diagnosedDate),
              SizedBox(height: spacing.xxl),
              if (notes.isNotEmpty) ...[
                RecordDetailsNotesCard(notes: notes),
                SizedBox(height: spacing.xxl),
              ],
              if (files.isNotEmpty) ...[
                RecordDetailsDocumentsSection(
                  files: files,
                  onViewAll: onViewAllFiles,
                  onFileTap: onFileTap,
                ),
              ],
              RecordDetailsBottomActions(onEdit: onEdit, onDelete: onDelete),
              SizedBox(height: spacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/widgets/record_details_bottom_actions.dart';
import 'package:cureta/features/medical_records/widgets/record_details_diagnosed_date.dart';
import 'package:cureta/features/medical_records/widgets/record_details_documents_section.dart';
import 'package:cureta/features/medical_records/widgets/record_details_header.dart';
import 'package:cureta/features/medical_records/widgets/record_details_notes_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    this.onFileTap,
  });

  final String conditionName;
  final bool isOngoing;
  final String diagnosedDate;
  final String notes;
  final List<RecordFile> files;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<int>? onFileTap;

  Future<void> _openFile(BuildContext context, RecordFile file) async {
    final url = file.fileUrl;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File URL is not available')),
      );
      return;
    }

    if (file.fileType == 'image') {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => Dialog.fullscreen(
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4,
                  child: Image.network(url, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: IconButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid file URL')));
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open attachment')),
      );
    }
  }

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
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: spacing.xl),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
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
                  if (files.isNotEmpty)
                    RecordDetailsDocumentsSection(
                      files: files,
                      onFileTap:
                          onFileTap ??
                          (index) => _openFile(context, files[index]),
                    ),
                  RecordDetailsBottomActions(
                    onEdit: onEdit,
                    onDelete: onDelete,
                  ),
                  SizedBox(height: spacing.xl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

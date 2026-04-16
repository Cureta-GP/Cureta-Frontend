import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/shared/widgets/document_file_tile.dart';
import 'package:flutter/material.dart';

/// Data class representing a single document/file attached to a record.
class RecordFile {
  const RecordFile({
    required this.name,
    required this.meta,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.fileType,
    this.fileUrl,
  });

  final String name;
  final String meta;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String fileType;
  final String? fileUrl;
}

/// Displays the "Documents & Files" section with a header row
/// (title + "View All" link) and a list of [DocumentFileTile] items.
class RecordDetailsDocumentsSection extends StatelessWidget {
  const RecordDetailsDocumentsSection({
    super.key,
    required this.files,
    this.onFileTap,
  });

  final List<RecordFile> files;
  final ValueChanged<int>? onFileTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.xs / 2),
          child: Text(
            AppLocalizations.recordDetailsDocumentsTitle,
            style: typography.medicalRecordScreenTitle.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: spacing.lg),
        // File list
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < files.length - 1 ? spacing.md : 0,
              ),
              child: DocumentFileTile(
                fileName: file.name,
                fileMeta: file.meta,
                fileIcon: file.icon,
                iconBgColor: file.iconBgColor,
                iconColor: file.iconColor,
                onTap: onFileTap != null ? () => onFileTap!(index) : null,
              ),
            );
          },
        ),
      ],
    );
  }
}

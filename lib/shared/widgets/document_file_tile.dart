import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

/// A reusable tile for displaying a document/file entry with an icon,
/// file name, metadata, and a trailing chevron action.
class DocumentFileTile extends StatelessWidget {
  const DocumentFileTile({
    super.key,
    required this.fileName,
    required this.fileMeta,
    required this.fileIcon,
    required this.iconBgColor,
    required this.iconColor,
    this.onTap,
  });

  final String fileName;
  final String fileMeta;
  final IconData fileIcon;
  final Color iconBgColor;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(width: 0.8, color: colors.divider),
          borderRadius: BorderRadius.circular(radius.xxl),
        ),
        child: Row(
          children: [
            // File type icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(radius.xl),
              ),
              child: Icon(fileIcon, size: 32, color: iconColor),
            ),
            SizedBox(width: spacing.lg),
            // File info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typography.medicalRecordUploadCardTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    fileMeta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typography.medicalRecordDetailLabel.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: spacing.md),
            // Chevron button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.chevron_right, size: 24, color: colors.icon),
            ),
          ],
        ),
      ),
    );
  }
}

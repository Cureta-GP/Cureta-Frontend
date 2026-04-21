import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/models/add_record_uploaded_file.dart';
import 'package:flutter/material.dart';

class AddRecordUploadedFileTile extends StatelessWidget {
  const AddRecordUploadedFileTile({
    super.key,
    required this.file,
    required this.onView,
    required this.onDelete,
  });

  final AddRecordUploadedFile file;
  final VoidCallback onView;
  final VoidCallback onDelete;

  String _formatSize(int bytes) {
    if (bytes <= 0) {
      return '0 B';
    }
    const kb = 1024;
    const mb = kb * 1024;
    if (bytes >= mb) {
      return '${(bytes / mb).toStringAsFixed(1)} MB';
    }
    if (bytes >= kb) {
      return '${(bytes / kb).toStringAsFixed(1)} KB';
    }
    return '$bytes B';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    final icon = file.isPdf ? Icons.picture_as_pdf : Icons.image_outlined;
    final iconBg = file.isPdf
        ? colors.error.withValues(alpha: 0.1)
        : colors.accentBlue;
    final iconColor = file.isPdf ? colors.error : colors.primary;

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius.xxl),
        border: Border.all(color: colors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: spacing.xxl + spacing.md,
            height: spacing.xxl + spacing.md,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(radius.xl),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: spacing.xl),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: typography.medicalRecordUploadCardTitle.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  '${file.extension.toUpperCase()} • ${_formatSize(file.sizeBytes)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: typography.medicalRecordDetailLabel.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: spacing.sm),
          IconButton(
            onPressed: onView,
            icon: Icon(Icons.visibility_outlined, color: colors.primary),
            tooltip: 'View file',
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline, color: colors.error),
            tooltip: 'Delete file',
          ),
        ],
      ),
    );
  }
}

import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/models/medical_record_model.dart';
import 'package:cureta/features/medical_records/widgets/user_record_status_pill.dart';
import 'package:flutter/material.dart';
import 'package:cureta/features/medical_records/widgets/record_details_documents_section.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class UserRecordCard extends StatelessWidget {
  const UserRecordCard({super.key, required this.record, this.onTap});

  final MedicalRecordModel record;
  final VoidCallback? onTap;

  String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    final dateStr = _formatDate(record.recordDate);
    final attachmentCount = record.attachments.length;
    final isOngoing = attachmentCount > 0;
    final meta = '$dateStr · $attachmentCount files';
    // Convert AttachmentModel to RecordFile for details screen
    final files = record.attachments.map((attachment) {
      final isImage =
          attachment.attachmentType.toLowerCase().contains('image') ||
          attachment.fileName.toLowerCase().endsWith('.jpg') ||
          attachment.fileName.toLowerCase().endsWith('.jpeg') ||
          attachment.fileName.toLowerCase().endsWith('.png') ||
          attachment.fileName.toLowerCase().endsWith('.gif');
      final isPdf = attachment.fileName.toLowerCase().endsWith('.pdf');
      return RecordFile(
        name: attachment.fileName,
        meta: attachment.attachmentType,
        icon: isPdf ? Icons.picture_as_pdf : Icons.image,
        iconBgColor: isPdf
            ? colors.error.withValues(alpha: 0.1)
            : colors.accentBlue,
        iconColor: isPdf ? colors.error : const Color(0xFF3B82F6),
        fileType: isPdf ? 'pdf' : (isImage ? 'image' : 'file'),
        fileUrl: attachment.fileUrl,
      );
    }).toList();

    return GestureDetector(
      onTap: () => GoRouter.of(context).pushNamed(
        AppRoutes.recordDetails,
        extra: {
          'conditionName': record.diseaseName,
          'isOngoing': isOngoing,
          'diagnosedDate': dateStr,
          'notes': record.notes ?? '',
          'files': files,
        },
      ),
      child: Container(
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(radius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserRecordStatusPill(
                        label: '$attachmentCount attachments',
                        isOngoing: isOngoing,
                      ),
                      SizedBox(height: spacing.md),
                      Text(
                        record.diseaseName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: typography.surfaceTitle.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.md),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: colors.textSecondary,
                ),
                SizedBox(width: spacing.xs),
                Expanded(
                  child: Text(
                    meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typography.medicalRecordUploadCardDescription
                        .copyWith(color: colors.textSecondary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/models/attachment_model.dart';
import 'package:flutter/material.dart';

/// Shows the attachments list in edit mode, allowing the user to mark
/// items for removal by tapping them.
class RecordDetailsEditableAttachments extends StatelessWidget {
  const RecordDetailsEditableAttachments({
    super.key,
    required this.attachments,
    required this.removeAttachmentIds,
    required this.isBusy,
    required this.onToggle,
  });

  final List<AttachmentModel> attachments;
  final Set<String> removeAttachmentIds;
  final bool isBusy;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) return const SizedBox.shrink();

    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.recordDetailsDocumentsTitle,
          style: typography.medicalRecordScreenTitle.copyWith(
            color: colors.textPrimary,
          ),
        ),
        SizedBox(height: spacing.xs),
        Text(
          AppLocalizations.recordDetailsRemoveAttachmentsHint,
          textAlign: TextAlign.start,
          style: typography.medicalRecordHelper.copyWith(
            color: colors.textSecondary,
          ),
        ),
        SizedBox(height: spacing.md),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: attachments.length,
          separatorBuilder: (_, _) => SizedBox(height: spacing.sm),
          itemBuilder: (context, index) {
            final attachment = attachments[index];
            return _AttachmentTile(
              attachment: attachment,
              marked: removeAttachmentIds.contains(attachment.id),
              isBusy: isBusy,
              onToggle: onToggle,
            );
          },
        ),
      ],
    );
  }
}

/// Private tile for a single attachment row in edit mode.
class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({
    required this.attachment,
    required this.marked,
    required this.isBusy,
    required this.onToggle,
  });

  final AttachmentModel attachment;
  final bool marked;
  final bool isBusy;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    return InkWell(
      borderRadius: BorderRadius.circular(radius.lg),
      onTap: isBusy ? null : () => onToggle(attachment.id),
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.md,
        ),
        decoration: BoxDecoration(
          color:
              marked ? colors.error.withValues(alpha: 0.08) : colors.surface,
          borderRadius: BorderRadius.circular(radius.lg),
          border: Border.all(
            color: marked
                ? colors.error.withValues(alpha: 0.45)
                : colors.divider,
            width: spacing.hairline,
          ),
        ),
        child: Row(
          children: [
            Icon(
              marked ? Icons.remove_circle_outline : Icons.attach_file,
              color: marked ? colors.error : colors.icon,
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: Text(
                attachment.fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: typography.medicalRecordHelper.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
            if (marked)
              Text(
                AppLocalizations.recordDetailsRemoveAttachment,
                style: typography.medicalRecordHelper.copyWith(
                  color: colors.error,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

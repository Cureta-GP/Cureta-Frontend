import 'package:cached_network_image/cached_network_image.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/models/attachment_model.dart';
import 'package:cureta/features/medical_records/widgets/record_details_documents_section.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// Formats a raw ISO date string to "MMM d, yyyy".
String formatRecordDate(String rawDate) {
  try {
    return DateFormat('MMM d, yyyy').format(DateTime.parse(rawDate));
  } catch (_) {
    return rawDate;
  }
}

/// Converts [AttachmentModel] list → [RecordFile] display models using theme tokens.
/// File-type detection delegated to [AttachmentModel.isPdf] / [AttachmentModel.fileType].
List<RecordFile> buildRecordFilesFromAttachments(
  BuildContext context,
  List<AttachmentModel> attachments,
) {
  final colors = context.colors;
  return attachments.map((a) => RecordFile(
        name: a.fileName,
        meta: a.attachmentType,
        icon: a.isPdf ? Icons.picture_as_pdf : Icons.image,
        iconBgColor:
            a.isPdf ? colors.error.withValues(alpha: 0.1) : colors.accentBlue,
        iconColor: a.isPdf ? colors.error : colors.primary,
        fileType: a.fileType,
        fileUrl: a.fileUrl,
      )).toList();
}

/// Opens a [RecordFile]: inline image viewer for images, external app for others.
///
/// [onError] receives a user-facing message when the file cannot be opened.
Future<void> openRecordFile(
  BuildContext context,
  RecordFile file, {
  required void Function(String) onError,
}) async {
  final url = file.fileUrl;
  if (url == null || url.isEmpty) {
    onError(AppLocalizations.recordDetailsFileUrlMissing);
    return;
  }

  if (file.fileType == 'image') {
    final spacing = context.spacing;
    await showDialog<void>(
      context: context,
      builder: (ctx) => Dialog.fullscreen(
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4,
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.contain,
                  placeholder: (context, _) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, _, __) => const Center(
                    child: Icon(Icons.broken_image_outlined, size: 48),
                  ),
                ),
              ),
            ),
            Positioned(
              top: spacing.md,
              right: spacing.md,
              child: IconButton(
                onPressed: () => Navigator.of(ctx).pop(),
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
    onError(AppLocalizations.recordDetailsInvalidFileUrl);
    return;
  }

  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched && context.mounted) {
    onError(AppLocalizations.recordDetailsOpenAttachmentError);
  }
}

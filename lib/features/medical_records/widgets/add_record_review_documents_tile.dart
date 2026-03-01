import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class AddRecordReviewDocumentsTile extends StatelessWidget {
  const AddRecordReviewDocumentsTile({super.key, required this.documentsCount});

  final int documentsCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(radius.xl),
      ),
      child: Row(
        children: [
          Container(
            width: spacing.xxl + spacing.lg,
            height: spacing.xxl + spacing.lg,
            decoration: BoxDecoration(
              color: colors.medicalRecordAccentSoft,
              borderRadius: BorderRadius.circular(radius.md),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.description,
              color: colors.primary,
              size: spacing.xl,
            ),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.addRecordReviewReports(documentsCount),
                  style: typography.medicalRecordChoice.copyWith(
                    color: colors.medicalRecordStrongText,
                  ),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  AppLocalizations.addRecordReviewDocumentsAttached,
                  style: typography.medicalRecordHelper.copyWith(
                    color: colors.medicalRecordMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: colors.primary, size: spacing.xl),
        ],
      ),
    );
  }
}

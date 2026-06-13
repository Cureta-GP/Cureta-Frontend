import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MedicineSyncBannerWidget extends StatelessWidget {
  const MedicineSyncBannerWidget({
    super.key,
    required this.failedCount,
    required this.onRetry,
  });

  final int failedCount;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Container(
      margin: EdgeInsetsDirectional.only(bottom: spacing.md),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.md,
      ),
      decoration: BoxDecoration(
        color: colors.accentOrange,
        borderRadius: BorderRadius.circular(context.radius.lg),
        border: Border.all(color: colors.divider),
      ),
      child: Row(
        children: [
          Icon(Icons.sync_problem, color: colors.textPrimary),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Text(
              'medicines.sync_failed_banner'.tr(args: [failedCount.toString()]),
              style: context.typography.label.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              AppLocalizations.medicinesRetry,
              style: context.typography.medicalRecordProgress.copyWith(
                color: colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

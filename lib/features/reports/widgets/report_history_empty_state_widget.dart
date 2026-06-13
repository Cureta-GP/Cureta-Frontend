import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/core/theme/theme_extensions.dart';

class ReportHistoryEmptyStateWidget extends StatelessWidget {
  const ReportHistoryEmptyStateWidget({super.key, required this.onGenerate});

  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final radius = context.radius;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_chart_outlined_rounded,
              size: spacing.xxl * 2,
              color: colors.icon,
            ),
            SizedBox(height: spacing.xl),
            Text(
              'reports.empty_title'.tr(),
              style: typography.title.copyWith(color: colors.textPrimary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.md),
            Text(
              'reports.empty_subtitle'.tr(),
              style: typography.body.copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.xxl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onGenerate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.background,
                  padding: EdgeInsets.symmetric(vertical: spacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius.full),
                  ),
                ),
                child: Text(
                  'reports.generate_first'.tr(),
                  style: typography.medicalRecordButton.copyWith(
                    color: colors.background,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

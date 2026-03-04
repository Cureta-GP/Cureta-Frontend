import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class AddRecordConditionSection extends StatelessWidget {
  const AddRecordConditionSection({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.addRecordConditionQuestion,
          style: typography.medicalRecordQuestion.copyWith(
            color: colors.textPrimary,
          ),
        ),
        SizedBox(height: spacing.xl),
        TextField(
          controller: controller,
          style: typography.medicalRecordInput.copyWith(
            color: colors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: AppLocalizations.addRecordTypeHint,
            hintStyle: typography.medicalRecordInput.copyWith(
              color: colors.textHint,
            ),
            filled: true,
            fillColor: colors.background,
            contentPadding: EdgeInsets.symmetric(
              horizontal: spacing.xl,
              vertical: spacing.md,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius.full),
              borderSide: BorderSide(color: colors.divider, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius.full),
              borderSide: BorderSide(color: colors.primary, width: 1.6),
            ),
          ),
        ),
        SizedBox(height: spacing.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, size: 16, color: colors.primary),
            SizedBox(width: spacing.xs),
            Expanded(
              child: Text(
                AppLocalizations.addRecordConditionExample,
                style: typography.medicalRecordHelper.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

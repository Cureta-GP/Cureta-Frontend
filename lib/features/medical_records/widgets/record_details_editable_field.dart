import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

/// An inline-editable text field used in the record details edit mode.
class RecordDetailsEditableField extends StatelessWidget {
  const RecordDetailsEditableField({
    super.key,
    required this.label,
    required this.controller,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final int minLines;
  final int maxLines;

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
          label,
          style: typography.medicalRecordDetailLabel.copyWith(
            color: colors.textSecondary,
          ),
        ),
        SizedBox(height: spacing.xs),
        TextField(
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          style: typography.medicalRecordInput.copyWith(
            color: colors.textPrimary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.surface,
            contentPadding: EdgeInsetsDirectional.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius.lg),
              borderSide: BorderSide(
                color: colors.divider,
                width: spacing.hairline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius.lg),
              borderSide: BorderSide(
                color: colors.divider,
                width: spacing.hairline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius.lg),
              borderSide: BorderSide(color: colors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

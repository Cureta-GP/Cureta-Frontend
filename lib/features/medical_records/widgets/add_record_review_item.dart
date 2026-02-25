import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class AddRecordReviewItem extends StatelessWidget {
  const AddRecordReviewItem({
    super.key,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Container(
      padding: EdgeInsets.only(bottom: spacing.lg),
      decoration: showDivider
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colors.medicalRecordProgressTrack,
                  width: spacing.hairline,
                ),
              ),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: typography.medicalRecordHelper.copyWith(
              color: colors.medicalRecordProgressText,
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            value,
            style: typography.medicalRecordPickerLabel.copyWith(
              color: colors.medicalRecordStrongText,
            ),
          ),
        ],
      ),
    );
  }
}

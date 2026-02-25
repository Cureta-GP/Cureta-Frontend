import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class AddRecordUploadCategoryTile extends StatelessWidget {
  const AddRecordUploadCategoryTile({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.title,
    required this.description,
    this.onTap,
  });

  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String title;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    final iconContainerSize = spacing.xxl * 2;
    final iconSize = spacing.xxl + spacing.xs;
    final addButtonSize = spacing.xxl;
    final addIconSize = spacing.lg + spacing.xs;

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: colors.medicalRecordCard,
        borderRadius: BorderRadius.circular(radius.xxl),
        border: Border.all(
          color: colors.medicalRecordUploadCardBorder,
          width: spacing.hairline,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: iconContainerSize,
            height: iconContainerSize,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(radius.xl),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: iconSize),
          ),
          SizedBox(width: spacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: typography.medicalRecordUploadCardTitle.copyWith(
                    color: colors.medicalRecordStrongText,
                  ),
                ),
                SizedBox(height: spacing.hairline * 2),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: typography.medicalRecordUploadCardDescription.copyWith(
                    color: colors.medicalRecordMuted,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: spacing.md),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius.full),
            child: Container(
              width: addButtonSize,
              height: addButtonSize,
              decoration: BoxDecoration(
                color: colors.medicalRecordUploadAddButtonBg,
                borderRadius: BorderRadius.circular(radius.full),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.add,
                color: colors.medicalRecordProgressText,
                size: addIconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

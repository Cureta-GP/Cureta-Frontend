import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class UserRecordsSearchBar extends StatelessWidget {
  const UserRecordsSearchBar({
    super.key,
    required this.controller,
    required this.hint,
    this.onFilterTap,
  });

  final TextEditingController controller;
  final String hint;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;
    const fieldHeight = 44.0;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: fieldHeight,
            decoration: BoxDecoration(
              color: colors.medicalRecordCard,
              borderRadius: BorderRadius.circular(radius.lg),
            ),
            child: TextField(
              controller: controller,
              style: typography.medicalRecordInput.copyWith(
                color: colors.medicalRecordStrongText,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: spacing.md,
                  vertical: spacing.md,
                ),
                prefixIcon: Icon(Icons.search, size: 20, color: colors.primary),
                hintText: hint,
                hintStyle: typography.medicalRecordHelper.copyWith(
                  color: colors.medicalRecordMuted,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: spacing.lg),
        Container(
          width: fieldHeight,
          height: fieldHeight,
          decoration: BoxDecoration(
            color: colors.medicalRecordCard,
            borderRadius: BorderRadius.circular(radius.lg),
          ),
          child: IconButton(
            onPressed: onFilterTap,
            padding: EdgeInsets.zero,
            icon: Icon(Icons.tune, size: 20, color: colors.primary),
          ),
        ),
      ],
    );
  }
}

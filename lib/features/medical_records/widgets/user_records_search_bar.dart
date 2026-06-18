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
              color: colors.surface,
              borderRadius: BorderRadius.circular(radius.lg),
            ),
            child: TextField(
              controller: controller,
              style: typography.medicalRecordInput.copyWith(
                color: colors.textPrimary,
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
                  color: colors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

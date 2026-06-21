import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class UserRecordsHeader extends StatelessWidget {
  const UserRecordsHeader({
    super.key,
    required this.title,
    this.onProfileTap,
    this.avatarInitial = 'U',
  });

  final String title;
  final VoidCallback? onProfileTap;
  final String avatarInitial;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: typography.medicalRecordScreenTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

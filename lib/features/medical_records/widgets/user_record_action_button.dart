import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class UserRecordActionButton extends StatelessWidget {
  const UserRecordActionButton({
    super.key,
    required this.isOngoing,
    this.onTap,
  });

  final bool isOngoing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius.full),
      child: Container(
        width: spacing.xxl + spacing.sm,
        height: spacing.xxl + spacing.sm,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(radius.full),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.chevron_right,
          size: spacing.xl,
          color: isOngoing ? colors.primary : colors.icon,
        ),
      ),
    );
  }
}

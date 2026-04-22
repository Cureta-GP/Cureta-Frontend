import 'package:flutter/material.dart';

import '../../../core/theme/theme_extensions.dart';

class ChatSessionTile extends StatelessWidget {
  const ChatSessionTile({
    super.key,
    required this.title,
    required this.dateText,
    required this.onTap,
  });

  final String title;
  final String dateText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final radius = context.radius;
    final colors = context.colors;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(radius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius.lg),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.md,
          ),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: spacing.xl + spacing.md,
                  height: spacing.xl + spacing.md,
                  child: Icon(
                    Icons.chat_bubble_outline,
                    size: spacing.lg + 2,
                    color: colors.primary,
                  ),
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.typography.chatQuickActionLabel,
                    ),
                    SizedBox(height: spacing.xs * 0.5),
                    Text(
                      dateText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.typography.label.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

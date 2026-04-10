import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/theme_extensions.dart';
import 'chat_bot_avatar.dart';

/// Top header bar for the chat screen.
///
/// Shows the bot avatar, title, online status indicator,
/// and a close button.
class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key, this.onClose});

  /// Called when the user taps the close button.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.md,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(bottom: BorderSide(width: 0.8, color: colors.divider)),
      ),
      child: Row(
        children: [
          const ChatBotAvatar(size: 40),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.chatAssistantTitle,
                  style: typography.chatHeaderTitle.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: spacing.xs * 0.25),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: ShapeDecoration(
                        color: colors.statusOnline,
                        shape: const CircleBorder(),
                      ),
                    ),
                    SizedBox(width: spacing.xs * 0.75),
                    Text(
                      AppLocalizations.chatOnlineStatus,
                      style: typography.chatStatusLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: colors.textSecondary),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

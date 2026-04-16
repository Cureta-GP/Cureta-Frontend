import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations.dart';
import 'chat_bot_avatar.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key, this.onMenu, required this.isLoading});

  final VoidCallback? onMenu;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: colorScheme.surface),
      child: Row(
        children: [
          const ChatBotAvatar(size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.chatAssistantTitle,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colorScheme.tertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isLoading
                          ? AppLocalizations.chatThinkingStatus
                          : AppLocalizations.chatOnlineStatus,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.menu, color: colorScheme.onSurfaceVariant),
            onPressed: onMenu,
          ),
        ],
      ),
    );
  }
}

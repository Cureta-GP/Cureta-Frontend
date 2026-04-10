import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/theme_extensions.dart';
import 'chat_bot_avatar.dart';
import 'chat_bubble.dart';
import 'chat_message.dart';

/// Layout row for an assistant message: avatar + bubble.
class AssistantMessageRow extends StatelessWidget {
  const AssistantMessageRow({super.key, required this.message});

  /// The assistant message to display.
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const ChatBotAvatar(size: 32),
        SizedBox(width: spacing.md),
        Expanded(
          child: ChatBubble(
            message: message.text,
            senderLabel: AppLocalizations.chatAssistantSender,
          ),
        ),
      ],
    );
  }
}

/// Layout row for a user message: bubble + avatar placeholder.
class UserMessageRow extends StatelessWidget {
  const UserMessageRow({super.key, required this.message});

  /// The user message to display.
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Spacer(),
        Flexible(
          flex: 4,
          child: ChatBubble(
            message: message.text,
            senderLabel: AppLocalizations.chatUserSender,
            isUser: true,
          ),
        ),
        SizedBox(width: spacing.md),
        Container(
          width: 32,
          height: 32,
          decoration: ShapeDecoration(
            color: colors.divider,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.full),
            ),
          ),
        ),
      ],
    );
  }
}

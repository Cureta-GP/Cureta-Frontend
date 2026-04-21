import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations.dart';
import '../data/models/chat_message_model.dart';
import 'chat_bot_avatar.dart';
import 'chat_bubble.dart';

/// Layout row for an assistant message: avatar + bubble.
class AssistantMessageRow extends StatelessWidget {
  const AssistantMessageRow({super.key, required this.message});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    final timeLabel = _formatTimestamp(context, message.createdAt);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const ChatBotAvatar(size: 32),
        const SizedBox(width: 12),
        Expanded(
          child: ChatBubble(
            message: message.content,
            senderLabel: AppLocalizations.chatAssistantSender,
            timestampLabel: timeLabel,
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(BuildContext context, DateTime dateTime) {
    final localTime = dateTime.toLocal();
    final timeOfDay = TimeOfDay.fromDateTime(localTime);
    final materialLocalizations = MaterialLocalizations.of(context);
    return materialLocalizations.formatTimeOfDay(
      timeOfDay,
      alwaysUse24HourFormat: false,
    );
  }
}

/// Layout row for a user message: bubble + avatar placeholder.
class UserMessageRow extends StatelessWidget {
  const UserMessageRow({super.key, required this.message});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final timeLabel = _formatTimestamp(context, message.createdAt);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Spacer(),
        Flexible(
          flex: 4,
          child: ChatBubble(
            message: message.content,
            senderLabel: AppLocalizations.chatUserSender,
            timestampLabel: timeLabel,
            isUser: true,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_outline,
            color: colorScheme.primary,
            size: 18,
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(BuildContext context, DateTime dateTime) {
    final localTime = dateTime.toLocal();
    final timeOfDay = TimeOfDay.fromDateTime(localTime);
    final materialLocalizations = MaterialLocalizations.of(context);
    return materialLocalizations.formatTimeOfDay(
      timeOfDay,
      alwaysUse24HourFormat: false,
    );
  }
}

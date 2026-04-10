import 'package:flutter/material.dart';

import '../../../core/theme/theme_extensions.dart';
import 'chat_message.dart';
import 'chat_message_row.dart';

/// Scrollable list of chat messages.
///
/// Uses [ListView.separated] for lazy loading. Each message
/// is rendered as either an [AssistantMessageRow] or a
/// [UserMessageRow].
class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    super.key,
    required this.messages,
  });

  /// Ordered list of messages to display.
  final List<ChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.xl,
      ),
      itemCount: messages.length,
      separatorBuilder: (_, __) =>
          SizedBox(height: spacing.xl),
      itemBuilder: (context, index) {
        final message = messages[index];

        if (message.isUser) {
          return UserMessageRow(message: message);
        }

        return AssistantMessageRow(message: message);
      },
    );
  }
}

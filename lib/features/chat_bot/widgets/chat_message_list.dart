import 'package:flutter/material.dart';

import '../data/models/chat_message_model.dart';
import 'chat_message_row.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.onScrollNotification,
  });

  final List<ChatMessageModel> messages;
  final ScrollController scrollController;
  final bool Function(ScrollNotification) onScrollNotification;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: onScrollNotification,
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: messages.length,
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final message = messages[index];
          if (message.isUser) {
            return UserMessageRow(message: message);
          }
          return AssistantMessageRow(message: message);
        },
      ),
    );
  }
}

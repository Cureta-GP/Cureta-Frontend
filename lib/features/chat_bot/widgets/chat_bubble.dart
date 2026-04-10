import 'package:flutter/material.dart';

import '../../../core/theme/theme_extensions.dart';

/// A single chat message bubble.
///
/// Renders differently for user vs. assistant messages:
/// - **User**: primary-coloured bg, rounded except bottom-right.
/// - **Assistant**: white/surface bg, rounded except bottom-left.
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.senderLabel,
    this.isUser = false,
  });

  /// The message body text.
  final String message;

  /// Label shown above the bubble (e.g. "You", "Assistant").
  final String senderLabel;

  /// Whether this bubble belongs to the current user.
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;
    final radius = context.radius;

    final bubbleRadius = BorderRadius.only(
      topLeft: Radius.circular(radius.xl),
      topRight: Radius.circular(radius.xl),
      bottomLeft: isUser
          ? Radius.circular(radius.xl)
          : Radius.zero,
      bottomRight: isUser
          ? Radius.zero
          : Radius.circular(radius.xl),
    );

    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          senderLabel,
          style: typography.chatSenderLabel.copyWith(
            color: isUser ? colors.icon : colors.chatAssistantLabel,
          ),
        ),
        SizedBox(height: spacing.xs * 0.75),
        Container(
          padding: EdgeInsets.all(spacing.lg),
          decoration: ShapeDecoration(
            color: isUser ? colors.primary : colors.background,
            shape: RoundedRectangleBorder(
              borderRadius: bubbleRadius,
            ),
          ),
          child: Text(
            message,
            style: typography.chatMessageBody.copyWith(
              color: isUser ? Colors.white : colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

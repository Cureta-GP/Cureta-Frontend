import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.senderLabel,
    required this.timestampLabel,
    this.isUser = false,
  });

  final String message;
  final String senderLabel;
  final String timestampLabel;
  final bool isUser;

  List<TextSpan> _parseMessage(String text) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.*?)\*\*', dotAll: true);
    int lastMatchEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bubbleColor = isUser
        ? colorScheme.primary
        : colorScheme.surfaceContainerHigh;
    final bubbleTextColor = isUser
        ? colorScheme.onPrimary
        : colorScheme.onSurface;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: Radius.circular(isUser ? 20 : 4),
      bottomRight: Radius.circular(isUser ? 4 : 20),
    );

    return Column(
      crossAxisAlignment: isUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          senderLabel,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          constraints: const BoxConstraints(maxWidth: 360),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: borderRadius,
            border: isUser
                ? null
                : Border.all(color: colorScheme.outlineVariant),
          ),
          child: Text.rich(
            TextSpan(
              children: _parseMessage(message),
            ),
            style: textTheme.bodyLarge?.copyWith(color: bubbleTextColor),
          ),
        ),
        if (timestampLabel.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            timestampLabel,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

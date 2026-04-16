/// Data model for a single chat message.
class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isUser,
  });

  /// The message body text.
  final String text;

  /// Whether this message was sent by the current user.
  final bool isUser;
}

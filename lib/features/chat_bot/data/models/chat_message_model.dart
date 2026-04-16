import 'package:equatable/equatable.dart';

class ChatMessageModel extends Equatable {
  final String id;
  final String role;
  final String content;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['_id'] ?? json['message_id'];
    final rawRole = json['role'] ?? json['sender_role'] ?? json['sender'];
    final rawContent =
        json['content'] ?? json['message'] ?? json['text'] ?? json['body'];
    final rawDate =
        json['created_at'] ?? json['createdAt'] ?? json['timestamp'];

    return ChatMessageModel(
      id: rawId?.toString() ?? DateTime.now().microsecondsSinceEpoch.toString(),
      role: rawRole?.toString() ?? 'assistant',
      content: rawContent?.toString() ?? '',
      createdAt: _parseDate(rawDate),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role,
    'content': content,
    'created_at': createdAt.toIso8601String(),
  };

  bool get isUser => role.toLowerCase() == 'user';

  bool get isAssistant => role.toLowerCase() == 'assistant';

  @override
  List<Object?> get props => [id, role, content, createdAt];

  static DateTime _parseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value)?.toUtc() ?? DateTime.now().toUtc();
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
    }
    return DateTime.now().toUtc();
  }
}

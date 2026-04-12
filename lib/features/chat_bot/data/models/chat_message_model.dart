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
    return ChatMessageModel(
      id: json['id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role,
    'content': content,
    'created_at': createdAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, role, content, createdAt];
}

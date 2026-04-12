import 'package:equatable/equatable.dart';

class ChatSessionModel extends Equatable {
  final String id;
  final String title;
  final DateTime createdAt;

  const ChatSessionModel({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    return ChatSessionModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'Chat',
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'created_at': createdAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, title, createdAt];
}

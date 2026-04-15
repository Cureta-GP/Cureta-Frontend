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
    final rawId = json['id'] ?? json['_id'] ?? json['session_id'];
    final rawTitle = json['title'] ?? json['name'] ?? json['subject'];
    final rawDate =
        json['created_at'] ?? json['createdAt'] ?? json['timestamp'];

    return ChatSessionModel(
      id: rawId?.toString() ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: rawTitle?.toString() ?? 'Chat',
      createdAt: _parseDate(rawDate),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'created_at': createdAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, title, createdAt];

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

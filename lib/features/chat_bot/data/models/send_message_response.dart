import 'package:equatable/equatable.dart';

class SendMessageResponse extends Equatable {
  final String sessionId;
  final String answer;

  const SendMessageResponse({required this.sessionId, required this.answer});

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    final rawSessionId =
        json['session_id'] ?? json['sessionId'] ?? json['chat_session_id'];
    final rawAnswer = json['answer'] ?? json['response'] ?? json['message'];

    return SendMessageResponse(
      sessionId: rawSessionId?.toString() ?? '',
      answer: rawAnswer?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'session_id': sessionId, 'answer': answer};

  @override
  List<Object?> get props => [sessionId, answer];
}

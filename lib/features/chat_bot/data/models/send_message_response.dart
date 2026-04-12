import 'package:equatable/equatable.dart';

class SendMessageResponse extends Equatable {
  final String sessionId;
  final String answer;

  const SendMessageResponse({required this.sessionId, required this.answer});

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    return SendMessageResponse(
      sessionId: json['session_id'] as String,
      answer: json['answer'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'session_id': sessionId, 'answer': answer};

  @override
  List<Object?> get props => [sessionId, answer];
}

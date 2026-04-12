import 'package:equatable/equatable.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import '../data/models/chat_message_model.dart';

sealed class ChatState extends Equatable {
  const ChatState();
}

class ChatInitial extends ChatState {
  const ChatInitial();

  @override
  List<Object?> get props => [];
}

class ChatLoading extends ChatState {
  final List<ChatMessageModel> messages;
  final String? sessionId;

  const ChatLoading(this.messages, {this.sessionId});

  @override
  List<Object?> get props => [messages, sessionId];
}

class ChatMessagesLoaded extends ChatState {
  final List<ChatMessageModel> messages;
  final String? sessionId;

  const ChatMessagesLoaded(this.messages, {this.sessionId});

  @override
  List<Object?> get props => [messages, sessionId];
}

class ChatError extends ChatState {
  final AppException error;

  const ChatError(this.error);

  @override
  List<Object?> get props => [error];
}

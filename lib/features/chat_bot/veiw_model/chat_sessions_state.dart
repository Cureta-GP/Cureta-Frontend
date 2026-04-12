import 'package:equatable/equatable.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import '../data/models/chat_session_model.dart';

sealed class ChatSessionsState extends Equatable {
  const ChatSessionsState();
}

class ChatSessionsInitial extends ChatSessionsState {
  const ChatSessionsInitial();

  @override
  List<Object?> get props => [];
}

class ChatSessionsLoading extends ChatSessionsState {
  const ChatSessionsLoading();

  @override
  List<Object?> get props => [];
}

class ChatSessionsSuccess extends ChatSessionsState {
  final List<ChatSessionModel> sessions;

  const ChatSessionsSuccess(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

class ChatSessionsError extends ChatSessionsState {
  final AppException error;

  const ChatSessionsError(this.error);

  @override
  List<Object?> get props => [error];
}

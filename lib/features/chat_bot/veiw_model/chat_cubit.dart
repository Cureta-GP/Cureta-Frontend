import 'dart:convert';

import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart'
    hide InMemoryChatController;
import 'package:uuid/uuid.dart';

import '../data/in_memory_chat_controller.dart';
import '../data/models/chat_message_model.dart';
import '../data/models/send_message_request.dart';
import '../data/models/send_message_response.dart';
import '../data/repo/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit()
    : _repository = getIt.get<ChatRepository>(),
      _profileRepository = getIt.get<ProfileRepository>(),
      super(const ChatState());

  final ChatRepository _repository;
  final ProfileRepository _profileRepository;
  final _uuid = const Uuid();
  final InMemoryChatController chatController = InMemoryChatController();

  final User currentUser = const User(id: 'patient');
  final User agent = const User(id: 'doctor');

  VoidCallback? onMessageInserted;
  String? _sessionId;

  void _log(String message) {
    debugPrint('[CHAT_CUBIT] $message');
  }

  Future<User?> resolveUser(String id) {
    if (id == currentUser.id) {
      return Future.value(currentUser);
    }
    if (id == agent.id) {
      return Future.value(agent);
    }
    return Future.value(null);
  }

  Future<void> loadMessages({required String sessionId}) async {
    _sessionId = sessionId;
    emit(state.copyWith(isLoading: true));
    _log('loadMessages start | sessionId=$sessionId');

    try {
      final backendMessages = await _repository.fetchMessages(
        sessionId: sessionId,
      );
      _log('loadMessages api returned ${backendMessages.length} messages');
      final uiMessages = backendMessages.map(_mapBackendMessageToUi).toList();
      _log('loadMessages mapped to ${uiMessages.length} UI messages');

      await chatController.setMessages(uiMessages);
      _log(
        'chatController now contains ${chatController.messages.length} messages',
      );
      emit(state.copyWith(isLoading: false, isEmpty: uiMessages.isEmpty));
      onMessageInserted?.call();
    } on AppException catch (error) {
      _log('loadMessages AppException: ${error.message}');
      await chatController.setMessages(const <Message>[]);
      emit(const ChatState(isLoading: false, isEmpty: true));
    } catch (error) {
      _log('loadMessages unexpected error: $error');
      await chatController.setMessages(const <Message>[]);
      emit(const ChatState(isLoading: false, isEmpty: true));
    }
  }

  Future<void> sendTextMessage(
    String text, {
    required String appLanguage,
    String? profileId,
  }) async {
    final normalized = text.trim();
    if (normalized.isEmpty) {
      return;
    }

    final resolvedProfileId = (profileId != null && profileId.isNotEmpty)
        ? profileId
        : await _profileRepository.getResolvedSelectedProfileId();
    _log(
      'sendTextMessage start | text="${normalized.substring(0, normalized.length.clamp(0, 60))}" | appLanguage=$appLanguage | sessionId=$_sessionId | profileId=$resolvedProfileId',
    );

    if (resolvedProfileId == null) {
      _log('sendTextMessage stopped: no profile selected');
      await _insertAssistantFallbackMessage(
        text: 'No profile selected yet. Please select a profile first.',
      );
      return;
    }

    final userMessage = TextMessage(
      id: _uuid.v4(),
      authorId: currentUser.id,
      createdAt: DateTime.now().toUtc(),
      text: normalized,
      metadata: const <String, dynamic>{'animate': false},
    );

    await chatController.insertMessage(userMessage);
    _log('inserted user message id=${userMessage.id}');
    emit(state.copyWith(isLoading: true, isEmpty: false));
    onMessageInserted?.call();

    try {
      final request = SendMessageRequest(
        message: normalized,
        profileId: resolvedProfileId,
        sessionId: _sessionId,
        appLanguage: appLanguage,
      );
      _log('sendMessage request payload: ${jsonEncode(request.toJson())}');

      final response = await _repository.sendMessage(request: request);
      _log(
        'sendMessage response parsed | sessionId=${response.sessionId} | answerLen=${response.answer.length}',
      );
      await _applyAssistantResponse(response);
    } on AppException catch (error) {
      _log('sendTextMessage AppException: ${error.message}');
      await _insertAssistantFallbackMessage(
        text: _toUserFacingErrorMessage(error.message),
      );
    } catch (error) {
      _log('sendTextMessage unexpected error: $error');
      await _insertAssistantFallbackMessage();
    } finally {
      emit(state.copyWith(isLoading: false, isEmpty: false));
      _log(
        'sendTextMessage end | isLoading=${state.isLoading} | messageCount=${chatController.messages.length}',
      );
    }
  }

  Future<void> startNewChat() async {
    _sessionId = null;
    await chatController.setMessages(const <Message>[]);
    emit(const ChatState(isLoading: false, isEmpty: true));
  }

  Future<void> _applyAssistantResponse(SendMessageResponse response) async {
    _sessionId = response.sessionId;
    _log('applyAssistantResponse | sessionId=$_sessionId');

    await _clearPendingAssistantAnimations();

    final assistantMessage = TextMessage(
      id: _uuid.v4(),
      authorId: agent.id,
      createdAt: DateTime.now().toUtc(),
      text: response.answer,
      metadata: const <String, dynamic>{'animate': true},
    );

    await chatController.insertMessage(assistantMessage);
    _log('inserted assistant message id=${assistantMessage.id}');
    onMessageInserted?.call();
  }

  Future<void> _insertAssistantFallbackMessage({String? text}) async {
    _log('inserting fallback assistant message');
    await chatController.insertMessage(
      TextMessage(
        id: _uuid.v4(),
        authorId: agent.id,
        createdAt: DateTime.now().toUtc(),
        text: text ?? 'Something went wrong. Please try again.',
        metadata: const <String, dynamic>{'animate': false},
      ),
    );
    onMessageInserted?.call();
  }

  Future<void> markMessageAnimationCompleted(TextMessage message) async {
    final metadata = message.metadata;
    if (metadata?['animate'] != true) {
      return;
    }

    final updated = message.copyWith(
      metadata: <String, dynamic>{...?metadata, 'animate': false},
    );
    await chatController.updateMessage(message, updated);
    _log('typewriter finished | messageId=${message.id}');
  }

  Future<void> _clearPendingAssistantAnimations() async {
    for (final item in chatController.messages.whereType<TextMessage>()) {
      final metadata = item.metadata;
      final shouldClear =
          item.authorId == agent.id && metadata?['animate'] == true;
      if (!shouldClear) {
        continue;
      }

      final updated = item.copyWith(
        metadata: <String, dynamic>{...?metadata, 'animate': false},
      );
      await chatController.updateMessage(item, updated);
    }
  }

  String _toUserFacingErrorMessage(String backendMessage) {
    final normalized = backendMessage.toLowerCase();
    if (normalized.contains('rag chat failed') ||
        normalized.contains('service unavailable') ||
        normalized.contains('high demand')) {
      return 'The AI assistant is currently busy. Please try again in a few moments.';
    }

    return backendMessage;
  }

  TextMessage _mapBackendMessageToUi(ChatMessageModel model) {
    final isUserMessage = model.role.toLowerCase() == 'user';
    _log('mapBackendMessageToUi | id=${model.id} | role=${model.role}');
    return TextMessage(
      id: model.id,
      authorId: isUserMessage ? currentUser.id : agent.id,
      createdAt: model.createdAt.toUtc(),
      text: model.content,
      metadata: const <String, dynamic>{'animate': false},
    );
  }

  @override
  Future<void> close() {
    chatController.dispose();
    return super.close();
  }
}

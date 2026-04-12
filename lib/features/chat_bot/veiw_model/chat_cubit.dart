import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import '../data/models/chat_message_model.dart';
import '../data/models/send_message_request.dart';
import '../data/repo/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit()
    : _repository = getIt.get<ChatRepository>(),
      _profileRepository = getIt.get<ProfileRepository>(),
      super(const ChatInitial());

  final ChatRepository _repository;
  final ProfileRepository _profileRepository;

  Future<void> loadMessages({required String sessionId}) async {
    emit(ChatLoading(const [], sessionId: sessionId));
    try {
      final messages = await _repository.fetchMessages(sessionId: sessionId);
      emit(ChatMessagesLoaded(messages, sessionId: sessionId));
    } on AppException catch (e) {
      emit(ChatError(e));
    } catch (_) {
      emit(ChatError(AppException.server()));
    }
  }

  Future<void> sendMessage({
    required String text,
    required String appLanguage,
    String? profileId,
    String? sessionId,
  }) async {
    final currentMessages = _getMessagesFromState();

    emit(ChatLoading(currentMessages, sessionId: sessionId));

    try {
      // Resolve profileId from repository if not provided
      final resolvedProfileId = (profileId != null && profileId.isNotEmpty)
          ? profileId
          : await _profileRepository.getResolvedSelectedProfileId();

      if (resolvedProfileId == null) {
        emit(ChatError(AppException.server(msg: 'No profile selected')));
        return;
      }

      final request = SendMessageRequest(
        message: text,
        profileId: resolvedProfileId,
        sessionId: sessionId,
        appLanguage: appLanguage,
      );

      final response = await _repository.sendMessage(request: request);

      final updatedMessages = [
        ...currentMessages,
        ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          role: 'user',
          content: text,
          createdAt: DateTime.now(),
        ),
        ChatMessageModel(
          id: '${DateTime.now().millisecondsSinceEpoch}_resp',
          role: 'assistant',
          content: response.answer,
          createdAt: DateTime.now(),
        ),
      ];

      emit(ChatMessagesLoaded(updatedMessages, sessionId: response.sessionId));
    } on AppException catch (e) {
      emit(ChatError(e));
    } catch (_) {
      emit(ChatError(AppException.server()));
    }
  }

  void startNewChat() {
    emit(const ChatInitial());
  }

  List<ChatMessageModel> _getMessagesFromState() {
    final state = this.state;
    if (state is ChatMessagesLoaded) return state.messages;
    if (state is ChatLoading) return state.messages;
    return [];
  }
}

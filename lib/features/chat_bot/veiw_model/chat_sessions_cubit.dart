import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import '../data/repo/chat_repository.dart';
import 'chat_sessions_state.dart';

class ChatSessionsCubit extends Cubit<ChatSessionsState> {
  ChatSessionsCubit(this._repository, this._profileRepository)
    : super(const ChatSessionsInitial());

  final ChatRepository _repository;
  final ProfileRepository _profileRepository;

  Future<void> fetchSessions({String? profileId}) async {
    emit(const ChatSessionsLoading());
    try {
      final resolvedProfileId = (profileId != null && profileId.isNotEmpty)
          ? profileId
          : await _profileRepository.getResolvedSelectedProfileId();

      if (resolvedProfileId == null) {
        if (isClosed) return;
        emit(
          ChatSessionsError(AppException.server(msg: 'No profile selected')),
        );
        return;
      }

      final sessions = await _repository.fetchSessions(
        profileId: resolvedProfileId,
      );
      if (isClosed) return;
      emit(ChatSessionsSuccess(sessions));
    } on AppException catch (e) {
      if (isClosed) return;
      emit(ChatSessionsError(e));
    } catch (_) {
      if (isClosed) return;
      emit(ChatSessionsError(AppException.server()));
    }
  }
}

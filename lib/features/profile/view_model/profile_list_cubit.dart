import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:cureta/features/profile/view_model/profile_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilesListCubit extends Cubit<ProfilesListState> {
  final ProfileRepository repository;

  ProfilesListCubit(this.repository) : super(ProfilesInitial());

  Future<void> getProfiles() async {
    emit(ProfilesLoading());
    try {
      final profiles = await repository.getProfiles();
      final cachedId = await repository.getCachedProfileId();
      final hasCached =cachedId != null && profiles.any((profile) => profile.id == cachedId);
      final initialId = hasCached
          ? cachedId
          : profiles
                .firstWhere((p) => p.isPrimary, orElse: () => profiles.first)
                .id;

      await repository.cacheSelectedProfileId(initialId);

      if (isClosed) return;
      emit(ProfilesSuccess(profiles, initialId));
    } catch (e) {
      if (isClosed) return;
      emit(ProfilesError(e.toString()));
    }
  }

  Future<void> selectProfile(String profileId) async {
    if (state is ProfilesSuccess) {
      final currentState = state as ProfilesSuccess;
      await repository.cacheSelectedProfileId(profileId);
      if (isClosed) return;
      emit(ProfilesSuccess(currentState.profiles, profileId));
    }
  }
  Future<void> deleteProfile(String profileId) async {
  try {
    await repository.deleteProfile(profileId: profileId);

    if (state is ProfilesSuccess) {
      final currentState = state as ProfilesSuccess;

      // ✅ شيل البروفايل المحذوف من الـ list
      final updatedProfiles = currentState.profiles
          .where((p) => p.id != profileId)
          .toList();

      if (updatedProfiles.isEmpty) {
        if (isClosed) return;
        emit(ProfilesSuccess([], null));
        return;
      }

      // ✅ لو المحذوف كان هو المختار، انتقل للـ primary
      String? newSelectedId = currentState.selectedProfileId;
      if (newSelectedId == profileId) {
        final fallback = updatedProfiles.firstWhere(
          (p) => p.isPrimary,
          orElse: () => updatedProfiles.first,
        );
        newSelectedId = fallback.id;
        await repository.cacheSelectedProfileId(newSelectedId);
      }

      if (isClosed) return;
      emit(ProfilesSuccess(updatedProfiles, newSelectedId));
    }
  } catch (e) {
    if (isClosed) return;
    emit(ProfilesError(e.toString()));
  }
}
}

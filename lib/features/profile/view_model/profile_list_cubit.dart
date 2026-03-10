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
      
      final initialId = profiles.firstWhere((p) => p.isPrimary).id;

      emit(ProfilesSuccess(profiles, initialId));
    } catch (e) {
      emit(ProfilesError(e.toString()));
    }
  }

  void selectProfile(String profileId) {
    if (state is ProfilesSuccess) {
      final currentState = state as ProfilesSuccess;
      emit(ProfilesSuccess(currentState.profiles, profileId));
    }
  }
}
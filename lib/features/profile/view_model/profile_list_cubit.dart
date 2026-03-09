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

      emit(ProfilesSuccess(profiles));
    } catch (e) {
      emit(ProfilesError(e.toString()));
    }
  }
}
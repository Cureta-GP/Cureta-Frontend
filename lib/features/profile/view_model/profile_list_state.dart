import 'package:cureta/features/profile/data/models/profile_model.dart';

abstract class ProfilesListState {}

class ProfilesInitial extends ProfilesListState {}

class ProfilesLoading extends ProfilesListState {}

class ProfilesSuccess extends ProfilesListState {
  final List<ProfileModel> profiles;

  ProfilesSuccess(this.profiles);
}

class ProfilesError extends ProfilesListState {
  final String message;

  ProfilesError(this.message);
}
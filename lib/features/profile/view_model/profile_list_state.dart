import 'package:cureta/features/profile/data/models/profile_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProfilesListState extends Equatable {
  const ProfilesListState();
}

class ProfilesInitial extends ProfilesListState {
  @override
  List<Object?> get props => [];
}

class ProfilesLoading extends ProfilesListState {
  @override
  List<Object?> get props => [];
}

class ProfilesSuccess extends ProfilesListState {
  final List<ProfileModel> profiles;
  final String? selectedProfileId;
  ProfilesSuccess(this.profiles, this.selectedProfileId);
  
  @override
  List<Object?> get props => [profiles, selectedProfileId];
}

class ProfilesError extends ProfilesListState {
  final String message;

  ProfilesError(this.message);

  @override
  List<Object?> get props => [message];
}
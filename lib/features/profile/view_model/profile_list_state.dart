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
  ProfilesSuccess(this.profiles);
  
  @override
  List<Object?> get props => [profiles];
  
}

class ProfilesError extends ProfilesListState {
  final String message;

  ProfilesError(this.message);

  @override
  List<Object?> get props => [message];
}
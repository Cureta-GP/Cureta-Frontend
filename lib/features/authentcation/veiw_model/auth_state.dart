// ──────────────────────────────────────────
//  AUTH STATES
// ──────────────────────────────────────────
import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:cureta/features/authentcation/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
  @override
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {
  const AuthLoading();
  @override
  List<Object?> get props => [];
}

class AuthSuccess extends AuthState {
  final UserModel user;
  const AuthSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final String message;
  final AppException? exception;
  const AuthError(this.message, {this.exception});
  @override
  List<Object?> get props => [message, exception];
}

class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
  @override
  List<Object?> get props => [];
}


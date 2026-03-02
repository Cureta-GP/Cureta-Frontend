import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import '../data/repo/auth_repository.dart';
import '../data/models/user_model.dart';

// ──────────────────────────────────────────
//  AUTH STATES
// ──────────────────────────────────────────
abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final UserModel user;
  const AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;
  final AppException? exception;

  const AuthError(this.message, {this.exception});
}

// ──────────────────────────────────────────
//  AUTH CUBIT
// ──────────────────────────────────────────
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository = getIt.get<AuthRepository>();

  AuthCubit() : super(const AuthInitial());

  // ──── Getters for convenience ────
  bool get isLoading => state is AuthLoading;
  UserModel? get user =>
      state is AuthSuccess ? (state as AuthSuccess).user : null;
  String? get errorMessage =>
      state is AuthError ? (state as AuthError).message : null;
  bool get isSuccess => state is AuthSuccess;

  // ──── Clear error ────
  void clearError() {
    if (state is AuthError) {
      emit(const AuthInitial());
    }
  }

  // ──── Reset state ────
  void _reset() {
    // Keep the current user if needed, but reset to initial for new actions
  }

  // ──────────────────────────────────────
  //  LOGIN
  // ──────────────────────────────────────
  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());

    try {
      final user = await _authRepository.login(
        email: email,
        password: password,
      );
      emit(AuthSuccess(user));
    } on AppException catch (e) {
      emit(AuthError(e.message, exception: e));
    } catch (e) {
      emit(AuthError(AppException.server().message));
    }
  }

  // ──────────────────────────────────────
  //  SIGN-UP
  // ──────────────────────────────────────
  Future<void> signUp({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      final user = await _authRepository.signUp(
        username: username,
        email: email,
        phone: phone,
        password: password,
      );
      emit(AuthSuccess(user));
    } on AppException catch (e) {
      emit(AuthError(e.message, exception: e));
    } catch (e) {
      emit(AuthError(AppException.server().message));
    }
  }

  // ──────────────────────────────────────
  //  LOGOUT
  // ──────────────────────────────────────
  Future<void> logout() async {
    await _authRepository.logout();
    emit(const AuthInitial());
  }
}

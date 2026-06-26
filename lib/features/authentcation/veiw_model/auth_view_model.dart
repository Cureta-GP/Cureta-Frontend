import 'package:cureta/features/authentcation/veiw_model/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import '../data/repo/auth_repository.dart';

// ──────────────────────────────────────────
//  AUTH STATES
// ──────────────────────────────────────────

// ──────────────────────────────────────────
//  AUTH CUBIT
// ──────────────────────────────────────────
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthInitial());

  // ──── Clear error ────
  void clearError() {
    if (state is AuthError) {
      emit(const AuthInitial());
    }
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
      if (isClosed) return;
      emit(AuthSuccess(user));
    } on AppException catch (e) {
      if (isClosed) return;
      emit(AuthError(e.message, exception: e));
    } catch (e) {
      if (isClosed) return;
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
      if (isClosed) return;
      emit(AuthSuccess(user));
    } on AppException catch (e) {
      if (isClosed) return;
      emit(AuthError(e.message, exception: e));
    } catch (e) {
      if (isClosed) return;
      emit(AuthError(AppException.server().message));
    }
  }

  // ──────────────────────────────────────
  //  LOGOUT
  // ──────────────────────────────────────
  Future<void> logout() async {
    await _authRepository.logout();
    if (isClosed) return;
    emit(const AuthInitial());
  }
}

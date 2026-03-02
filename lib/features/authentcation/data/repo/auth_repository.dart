import 'package:shared_preferences/shared_preferences.dart';
import 'package:cureta/core/error_handling/error_handler.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:cureta/core/Services/dio_helper.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  // ────────────────────────────────────────
  //  LOGIN
  // ────────────────────────────────────────
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      if (!authResponse.isSuccess) {
        throw AppException.validation(
          msg: authResponse.message ?? 'Login failed',
        );
      }

      await _persistTokenAndReinitDio(authResponse.data!.token);
      return authResponse.data!;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // ────────────────────────────────────────
  //  SIGN-UP
  // ────────────────────────────────────────
  Future<UserModel> signUp({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _authService.signUp(
        username: username,
        email: email,
        phone: phone,
        password: password,
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      if (!authResponse.isSuccess) {
        throw AppException.validation(
          msg: authResponse.message ?? 'Registration failed',
        );
      }

      await _persistTokenAndReinitDio(authResponse.data!.token);
      return authResponse.data!;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // ────────────────────────────────────────
  //  TOKEN PERSISTENCE
  // ────────────────────────────────────────
  Future<void> _persistTokenAndReinitDio(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    // Re-initialise Dio so the new token is used for all subsequent requests.
    await DioHelper.init();
  }

  // ────────────────────────────────────────
  //  LOGOUT (bonus utility)
  // ────────────────────────────────────────
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await DioHelper.init();
  }

  /// Check if a persisted token exists (for splash / auto-login logic).
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }
}

import 'package:dio/dio.dart';
import 'package:cureta/core/Services/dio_helper.dart';
import 'package:cureta/core/constants/api_endpoints.dart';
class AuthService {
  /// POST auth/login
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await DioHelper.postData(
      url: ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
  }

  /// POST auth/signup
  Future<Response> signUp({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    return await DioHelper.postData(
      url: ApiEndpoints.register,
      data: {
        'username': username,
        'email': email,
        'phone': phone,
        'password': password,
      },
    );
  }

  /// POST auth/logout
  Future<Response> logout() async {
    return await DioHelper.postData(
      url: ApiEndpoints.logout,
      data: {},
    );
  }

  /// POST auth/forgot-password
  Future<Response> forgotPassword({required String email}) async {
    return await DioHelper.postData(
      url: ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
  }
  /// POST auth/reset-password
  Future<Response> resetPassword({
    required String otp,
    required String newPassword,
  }) async {
    return await DioHelper.postData(
      url: ApiEndpoints.resetPassword,
      data: {
        'otp': otp,
        'newPassword': newPassword,
      },
    );
  }

}

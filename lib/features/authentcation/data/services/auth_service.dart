import 'package:dio/dio.dart';
import 'package:cureta/core/Services/dio_helper.dart';

class AuthService {
  /// POST auth/login
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await DioHelper.postData(
      url: 'auth/login',
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
      url: 'auth/signup',
      data: {
        'username': username,
        'email': email,
        'phone': phone,
        'password': password,
      },
    );
  }
}

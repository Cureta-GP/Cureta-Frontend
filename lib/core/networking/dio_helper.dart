import 'package:cureta/core/networking/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioHelper {
  static Dio? dio;

  static initDio() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      dio!.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  static void _setToken(String? token) {
    if (token != null) {
      dio!.options.headers['Authorization'] = 'Bearer $token';
    } else {
      dio!.options.headers.remove('Authorization');
    }
  }

  // --- GET ---
  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    _setToken(token);
    return await dio!.get(url, queryParameters: query);
  }

  // --- POST ---
  static Future<Response> postData({
    required String url,
    required dynamic data, 
    Map<String, dynamic>? query,
    String? token,
  }) async {
    _setToken(token);
    return await dio!.post(url, data: data, queryParameters: query);
  }

  // --- PUT ---
  static Future<Response> putData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    _setToken(token);
    return await dio!.put(url, data: data, queryParameters: query);
  }

  // --- DELETE ---
  static Future<Response> deleteData({
    required String url,
    dynamic data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    _setToken(token);
    return await dio!.delete(url, data: data, queryParameters: query);
  }
}
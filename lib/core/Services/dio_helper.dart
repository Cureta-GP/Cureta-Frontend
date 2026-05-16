import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class DioHelper {
  static Dio? dio;
  static String baseurl = "https://cureta.onrender.com/api/";

  static Map<String, dynamic> _buildHeaders(String? token) {
    final headers = <String, dynamic>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    dio = Dio(
      BaseOptions(
        baseUrl: baseurl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: _buildHeaders(token),
      ),
    );

    // Add interceptor to log requests and responses (especially error bodies)
    dio!.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  static void setAuthToken(String token) {
    final client = dio;
    if (client == null) return;
    client.options.headers['Authorization'] = 'Bearer $token';
  }

  static void clearAuthToken() {
    final client = dio;
    if (client == null) return;
    client.options.headers.remove('Authorization');
  }

  static Future<Response> getData({
    required String url,
    required Map<String, dynamic> query,
  }) async {
    return await dio!.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    return dio!.post(url, queryParameters: query, data: data);
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    required dynamic data,
  }) async {
    return dio!.put(
      url,
      queryParameters: query,
      data: data,
      options: Options(
        contentType: data is FormData ? null : 'application/json',
      ),
    );
  }

  static Future<Response> putFormData({
    required String url,
    Map<String, dynamic>? query,
    required FormData data,
  }) async {
    return await dio!.put(
      url,
      queryParameters: query,
      data: data,
      options: Options(contentType: null),
    );
  }

  static Future<Response> patchData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
  }) async {
    return dio!.patch(url, queryParameters: query, data: data);
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    return await dio!.delete(url, queryParameters: query, data: data);
  }

  /// Sends POST with multipart/form-data (file uploads).
  static Future<Response> postFormData({
    required String url,
    Map<String, dynamic>? query,
    required FormData data,
  }) async {
    return await dio!.post(
      url,
      queryParameters: query,
      data: data,
      options: Options(
        // Let Dio auto-set 'multipart/form-data; boundary=xxx' from FormData
        contentType: null,
      ),
    );
  }
}

// core/error_handling/error_handler.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'app_exceptions.dart';

class ErrorHandler {
  /// تحويل أي خطأ إلى AppException
  static AppException handle(dynamic error) {
    if (error is AppException) return error;
    if (error is SocketException) return AppException.network();
    if (error is DioException) return _handleDio(error);
    return AppException.server();
  }

  static AppException _handleDio(DioException error) {
    // Timeout
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return AppException.timeout();
    }

    // No internet
    if (error.type == DioExceptionType.connectionError) {
      return AppException.network();
    }

    final status = error.response?.statusCode;
    final data = error.response?.data;

    // ========== غيّر هنا حسب الباك إند ==========
    final msg = data is Map ? data['message'] : null;
    final code = data is Map ? data['code']?.toString() : null;
    final fields = data is Map && data['errors'] is Map
        ? Map<String, String>.from(data['errors'])
        : null;
    // ============================================

    // Error code mapping
    if (code != null) {
      switch (code.toUpperCase()) {
        case 'UNAUTHORIZED':
        case 'INVALID_CREDENTIALS':
          return AppException.unauthorized();
        case 'ACCOUNT_SUSPENDED':
          return AppException.suspended();
        case 'EMAIL_ALREADY_EXISTS':
          return AppException.emailExists();
        case 'WEAK_PASSWORD':
          return AppException.weakPassword();
        case 'INVALID_EMAIL':
          return AppException.invalidEmail();
        case 'VALIDATION_ERROR':
          return AppException.validation(msg: msg, fields: fields);
        case 'NOT_FOUND':
          return AppException.notFound();
        // أضف codes جديدة هنا ↓
      }
    }

    // HTTP status codes
    switch (status) {
      case 400:
      case 422:
        return AppException.validation(msg: msg, fields: fields);
      case 401:
        return AppException.unauthorized();
      case 403:
        return AppException.suspended();
      case 404:
        return AppException.notFound();
      default:
        return AppException.server(msg);
    }
  }

  /// عرض الخطأ
  static void show(
    BuildContext context,
    AppException error, {
    VoidCallback? onRetry,
  }) {
    switch (error.type) {
      case ErrorType.snackbar:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;

      case ErrorType.dialog:
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('تنبيه'),
            content: Text(error.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              if (onRetry != null)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onRetry();
                  },
                  child: const Text('إعادة المحاولة'),
                ),
            ],
          ),
        );
        break;

      case ErrorType.fullScreen:
      case ErrorType.inline:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
    }
  }
}

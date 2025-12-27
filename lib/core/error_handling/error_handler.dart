// core/error_handling/error_handler.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'app_exceptions.dart';

/// معالج الأخطاء - تحويل + عرض
class ErrorHandler {
  /// تحويل أي خطأ إلى AppException
  static AppException handle(dynamic error) {
    if (error is AppException) return error;
    if (error is SocketException) return AppException.network();

    if (error is DioException) {
      return _handleDio(error);
    }

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

    // Response errors
    final status = error.response?.statusCode;
    final data = error.response?.data;
    final msg = data is Map ? data['message'] : null;
    final code = data is Map ? data['code'] : null;

    // Backend error codes
    if (code != null) {
      return _mapCode(code, msg);
    }

    // HTTP status codes
    switch (status) {
      case 401:
        return AppException.unauthorized();
      case 404:
        return AppException.notFound();
      case 422:
        return AppException.validation(
          fields: data is Map && data['errors'] is Map
              ? Map<String, String>.from(data['errors'])
              : null,
        );
      default:
        return AppException.server(msg);
    }
  }

  static AppException _mapCode(String code, String? msg) {
    switch (code) {
      case 'ACCOUNT_SUSPENDED':
        return AppException.suspended();
      case 'EMAIL_ALREADY_EXISTS':
        return AppException.emailExists();
      case 'WEAK_PASSWORD':
        return AppException.weakPassword();
      case 'INVALID_EMAIL':
        return AppException.invalidEmail();
      case 'INVALID_CREDENTIALS':
        return AppException.unauthorized();
      // أضف error codes جديدة هنا
      default:
        return AppException.server(msg);
    }
  }

  /// عرض الخطأ - يرجع fieldErrors للـ inline
  static Map<String, String>? show(
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
        return null;

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
        return null;

      case ErrorType.inline:
        return error.fieldErrors ?? {'general': error.message};

      case ErrorType.fullScreen:
        return null; // UI handles with AppErrorWidget
    }
  }
}

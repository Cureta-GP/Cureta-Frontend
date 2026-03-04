// core/error_handling/app_exceptions.dart

/// نوع عرض الخطأ
enum ErrorType {
  fullScreen, // شاشة كاملة
  dialog, // نافذة منبثقة
  snackbar, // رسالة أسفل الشاشة
  inline, // داخل الـ TextField
}

/// كل الأخطاء في كلاس واحد
class AppException implements Exception {
  final String message;
  final ErrorType type;
  final Map<String, String>? fieldErrors;

  AppException(this.message, this.type, {this.fieldErrors});

  @override
  String toString() => message;

  // ========== Network ==========
  factory AppException.network() =>
      AppException('لا يوجد اتصال بالإنترنت', ErrorType.fullScreen);

  factory AppException.timeout() =>
      AppException('انتهت مهلة الاتصال', ErrorType.fullScreen);

  // ========== Server ==========
  factory AppException.server({String? msg}) =>
      AppException(msg ?? 'حدث خطأ في الخادم', ErrorType.fullScreen);

  factory AppException.notFound({String? msg}) =>
      AppException(msg ?? 'البيانات غير موجودة', ErrorType.fullScreen);

  // ========== Auth ==========
  factory AppException.unauthorized({String? msg}) =>
      AppException(msg ?? 'انتهت الجلسة، سجل دخول مرة أخرى', ErrorType.dialog);

  factory AppException.suspended({String? msg}) =>
      AppException(msg ?? 'حسابك موقوف، تواصل مع الدعم', ErrorType.dialog);

  factory AppException.emailExists() =>
      AppException('البريد الإلكتروني مستخدم', ErrorType.snackbar);

  // ========== Validation ==========
  factory AppException.validation({String? msg, Map<String, String>? fields}) =>
      AppException(
        msg ?? 'تحقق من البيانات',
        ErrorType.inline,
        fieldErrors: fields,
      );

  factory AppException.invalidEmail() => AppException(
    'البريد غير صحيح',
    ErrorType.inline,
    fieldErrors: {'email': 'البريد غير صحيح'},
  );

  factory AppException.weakPassword() => AppException(
    'كلمة المرور ضعيفة',
    ErrorType.inline,
    fieldErrors: {'password': 'كلمة المرور ضعيفة'},
  );

  // ========== إضافة خطأ جديد ==========
  // factory AppException.yourNewError() =>
  //     AppException('رسالة الخطأ', ErrorType.snackbar);
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Nav {
  /// Navigate to a route (replaces current history)
  /// الانتقال لصفحة (يستبدل التاريخ)
  static void to(BuildContext context, String path, {Object? extra}) {
    context.go(path, extra: extra);
  }

  /// Push a new route on top of current
  /// فتح صفحة جديدة فوق الحالية
  static Future<T?> push<T>(BuildContext context, String path, {Object? extra}) {
    return context.push<T>(path, extra: extra);
  }

  /// Replace current route
  /// استبدال الصفحة الحالية
  static void replace<T>(BuildContext context, String path, {Object? extra}) {
    return context.pushReplacement(path, extra: extra);
  }

  /// Go back to previous page
  /// الرجوع للصفحة السابقة
  static void back<T>(BuildContext context, [T? result]) {
    if (context.canPop()) {
      context.pop(result);
    }
  }

  /// Clear all and navigate to route
  /// مسح كل الصفحات والذهاب لصفحة جديدة
  static void clearAndGo(BuildContext context, String path, {Object? extra}) {
    while (context.canPop()) {
      context.pop();
    }
    context.go(path, extra: extra);
  }

  /// Check if can go back
  /// التحقق من إمكانية الرجوع
  static bool canGoBack(BuildContext context) {
    return context.canPop();
  }

  /// Navigate by route name
  /// الانتقال باسم المسار
  static void toNamed(BuildContext context, String name, {Object? extra, Map<String, String>? params}) {
    context.goNamed(name, extra: extra, pathParameters: params ?? {});
  }

  /// Push by route name
  /// فتح صفحة باسم المسار
  static Future<T?> pushNamed<T>(BuildContext context, String name, {Object? extra, Map<String, String>? params}) {
    return context.pushNamed<T>(name, extra: extra, pathParameters: params ?? {});
  }
}
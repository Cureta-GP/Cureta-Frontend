// core/error_handling/app_error_widget.dart

import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'app_exceptions.dart';

/// Widget للأخطاء الكبيرة (fullScreen)
class AppErrorWidget extends StatelessWidget {
  final AppException error;
  final VoidCallback? onRetry;

  const AppErrorWidget({super.key, required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;
    final colors = context.colors;
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: spacing.xxl * 4,
              width: spacing.xxl * 4,
              decoration: BoxDecoration(
                color: scheme.errorContainer,
                borderRadius: BorderRadius.circular(radius.full),
              ),
              child: Icon(
                _getIcon(),
                size: spacing.xxl * 2,
                color: scheme.error,
              ),
            ),
            SizedBox(height: spacing.xxl),
            Text(
              error.message,
              textAlign: TextAlign.center,
              style: typography.title.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: spacing.xxl),
            if (onRetry != null)
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.xxl,
                    vertical: spacing.md,
                  ),
                ),
                child: Text('إعادة المحاولة', style: typography.button),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    final msg = error.message;
    if (msg.contains('اتصال') || msg.contains('إنترنت')) return Icons.wifi_off;
    if (msg.contains('مهلة')) return Icons.access_time;
    if (msg.contains('موجودة')) return Icons.search_off;
    return Icons.cloud_off;
  }
}

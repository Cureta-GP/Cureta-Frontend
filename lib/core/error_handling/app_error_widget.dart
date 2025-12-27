// core/error_handling/app_error_widget.dart

import 'package:flutter/material.dart';
import 'app_exceptions.dart';

/// Widget للأخطاء الكبيرة (fullScreen)
class AppErrorWidget extends StatelessWidget {
  final AppException error;
  final VoidCallback? onRetry;

  const AppErrorWidget({super.key, required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(_getIcon(), size: 60, color: Colors.red.shade300),
            ),
            const SizedBox(height: 24),
            Text(
              error.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            if (onRetry != null)
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('إعادة المحاولة'),
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

import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class RecordsErrorView extends StatelessWidget {
  const RecordsErrorView({super.key, required this.error, this.onRetry});

  final String error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colors.error),
            SizedBox(height: spacing.md),
            Text(
              error,
              textAlign: TextAlign.center,
              style: context.typography.medicalRecordHelper.copyWith(
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: spacing.lg),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

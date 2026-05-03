import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MedicineListErrorWidget extends StatelessWidget {
  const MedicineListErrorWidget({
    super.key,
    required this.messageKey,
    required this.onRetry,
  });

  final String messageKey;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: context.spacing.xxl * 1.5,
              color: context.colors.error,
            ),
            SizedBox(height: context.spacing.md),
            Text(
              messageKey.tr(),
              style: context.typography.body.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.spacing.lg),
            ElevatedButton(
              onPressed: onRetry,
              child: Text('medicines.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class UserRecordsScanRxItem extends StatelessWidget {
  const UserRecordsScanRxItem({
    super.key,
    required this.label,
    required this.active,
    this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;
    final size = spacing.xxl * 2;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: active ? 1.06 : 1,
        duration: const Duration(milliseconds: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(radius.full),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.document_scanner,
                color: Colors.white,
                size: spacing.xxl,
              ),
            ),
            SizedBox(height: spacing.xs / 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: typography.medicalRecordProgress.copyWith(
                color: colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

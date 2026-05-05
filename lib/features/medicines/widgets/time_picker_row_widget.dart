import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';

class TimePickerRowWidget extends StatelessWidget {
  const TimePickerRowWidget({
    super.key,
    required this.time,
    required this.onTap,
    required this.onRemove,
    required this.canRemove,
  });

  final String time;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final bool canRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: context.spacing.lg,
          vertical: context.spacing.md,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(context.radius.lg),
          border: Border.all(color: context.colors.divider),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, color: context.colors.primary),
            SizedBox(width: context.spacing.md),
            Text(
              time,
              style: context.typography.medicalRecordPickerLabel.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            const Spacer(),
            if (canRemove)
              IconButton(
                onPressed: onRemove,
                icon: Icon(Icons.close, color: context.colors.error),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }
}

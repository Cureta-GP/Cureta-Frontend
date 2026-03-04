import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class CustomTopBar extends StatelessWidget {
  const CustomTopBar({
    super.key,
    this.onBack,
    this.onAction,
    this.actionLabel,
    this.actionStyle,
  });

  final VoidCallback? onBack;
  final VoidCallback? onAction;
  final String? actionLabel;
  final TextStyle? actionStyle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.lg,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            style: IconButton.styleFrom(
              minimumSize: const Size(40, 40),
              shape: const CircleBorder(),
            ),
            icon: Icon(Icons.arrow_back_ios_new, color: colors.icon, size: 22),
          ),
          const Spacer(),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction ?? () => Navigator.of(context).maybePop(),
              child: Text(
                actionLabel!,
                style:
                    actionStyle ??
                    typography.medicalRecordCancel.copyWith(
                      color: colors.textSecondary,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}

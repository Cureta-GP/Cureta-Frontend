import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class CustomScreenHeader extends StatelessWidget {
  const CustomScreenHeader({
    super.key,
    required this.title,
    this.onBack,
    this.titleStyle,
    this.iconColor,
  });

  final String title;
  final VoidCallback? onBack;
  final TextStyle? titleStyle;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.md,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            style: IconButton.styleFrom(
              minimumSize: const Size(48, 48),
              shape: const CircleBorder(),
            ),
            icon: Icon(
              Icons.arrow_back,
              color: iconColor ?? colors.medicalRecordStrongText,
              size: 28,
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: titleStyle ??
                  typography.medicalRecordScreenTitle.copyWith(
                    color: colors.medicalRecordStrongText,
                  ),
            ),
          ),
          const SizedBox(width: 48), // Spacer for symmetry
        ],
      ),
    );
  }
}

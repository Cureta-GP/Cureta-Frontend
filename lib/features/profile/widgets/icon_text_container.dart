import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class IconTextContainer extends StatelessWidget {
  final String label;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const IconTextContainer({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final radius = context.radius;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.4,
        //duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: spacing.lg,
          horizontal: spacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.accentCyan : colors.background,
          borderRadius: BorderRadius.circular(radius.md),
          border: Border.all(
            color: isSelected ? colors.primary : colors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.primary.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              height: spacing.md * 2,
              width: spacing.md * 2,
              fit: BoxFit.contain,
              color: isSelected ? colors.primary : colors.icon,
            ),
            SizedBox(height: spacing.sm),
            Text(
              label,
              style: typography.medicalRecordChoice.copyWith(
                color: isSelected ? colors.primary : colors.textPrimary,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

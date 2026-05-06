import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';

class MedicineLogTimelineWidget extends StatelessWidget {
  const MedicineLogTimelineWidget({
    super.key,
    required this.color,
    required this.icon,
    required this.isLast,
  });

  final Color color;
  final IconData icon;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;

    return SizedBox(
      width: spacing.xl,
      child: Column(
        children: [
          Container(
            width: spacing.lg,
            height: spacing.lg,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: spacing.md, color: color),
          ),
          if (!isLast)
            Container(
              width: spacing.hairline,
              height: spacing.xl,
              color: colors.divider,
            ),
        ],
      ),
    );
  }
}

import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:flutter/material.dart';

class ArrowBack extends StatelessWidget {
  const ArrowBack({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radius;
    final spacing = context.spacing;

    return Container(
      width: spacing.xxl + spacing.md,
      height: spacing.xxl + spacing.md,
      decoration: ShapeDecoration(
        color: colors.primary.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.full),
        ),
      ),
      child: IconButton(
        onPressed: () => Nav.back(context),
        icon: Icon(Icons.arrow_back, color: colors.primary),
      ),
    );
  }
}

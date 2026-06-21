import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class FilterCard extends StatelessWidget {
  final Widget child;
  const FilterCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radius;
    final spacing = context.spacing;

    return Card(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.lg),
        side: BorderSide(color: colors.divider),
      ),
      child: Padding(padding: EdgeInsets.all(spacing.md), child: child),
    );
  }
}

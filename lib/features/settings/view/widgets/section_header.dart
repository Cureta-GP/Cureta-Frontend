import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: context.spacing.xs),
      child: Text(
        label,
        style: context.typography.label.copyWith(
          color: context.colors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

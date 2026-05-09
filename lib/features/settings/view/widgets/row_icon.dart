import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class RowIcon extends StatelessWidget {
  const RowIcon({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: context.colors.accentCyan,
        borderRadius: BorderRadius.circular(context.radius.md),
      ),
      child: Icon(icon, color: context.colors.primary, size: 18),
    );
  }
}

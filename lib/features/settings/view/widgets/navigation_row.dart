import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/settings/view/widgets/row_icon.dart';
import 'package:flutter/material.dart';

class NavigationRow extends StatelessWidget {
  const NavigationRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.md,
          vertical: context.spacing.md,
        ),
        child: Row(
          children: [
            RowIcon(icon: icon),
            SizedBox(width: context.spacing.md),
            Expanded(
              child: Text(
                label,
                style: context.typography.body.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: colors.icon, size: 20),
          ],
        ),
      ),
    );
  }
}

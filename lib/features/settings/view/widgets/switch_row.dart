import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/settings/view/widgets/row_icon.dart';
import 'package:flutter/material.dart';

class SwitchRow extends StatelessWidget {
  const SwitchRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.md,
        vertical: context.spacing.xs,
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: colors.primary,
          ),
        ],
      ),
    );
  }
}

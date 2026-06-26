import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

/// Displays a live checklist of password-strength requirements.
/// Each row turns from hint-coloured to primary-coloured as the rule is met.
class PasswordRequirementsWidget extends StatelessWidget {
  const PasswordRequirementsWidget({super.key, required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    final rules = [
      (AppLocalizations.passwordReqLength, password.length >= 8),
      (
        AppLocalizations.passwordReqUppercase,
        password.contains(RegExp(r'[A-Z]')),
      ),
      (
        AppLocalizations.passwordReqLowercase,
        password.contains(RegExp(r'[a-z]')),
      ),
      (AppLocalizations.passwordReqNumber, password.contains(RegExp(r'[0-9]'))),
      (
        AppLocalizations.passwordReqSpecial,
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>\[\]\\/_\-+=~`]')),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < rules.length; i++) ...[
          if (i > 0) SizedBox(height: spacing.xs / 2),
          _RequirementRow(label: rules[i].$1, met: rules[i].$2),
        ],
      ],
    );
  }
}

class _RequirementRow extends StatelessWidget {
  const _RequirementRow({required this.label, required this.met});

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final color = met ? colors.primary : colors.textHint;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          met
              ? Icons.check_circle_outline_rounded
              : Icons.radio_button_unchecked_rounded,
          size: 14,
          color: color,
        ),
        SizedBox(width: context.spacing.xs),
        Expanded(
          child: Text(
            label,
            style: typography.label.copyWith(color: color, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

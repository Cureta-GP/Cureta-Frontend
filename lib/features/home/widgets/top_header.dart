import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm, 
        vertical: spacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.homeWelcomeBack,
                  style: typography.homeWelcomeBack.copyWith(
                    color: colors.textSecondary,
                    height: 1.2,
                    fontSize: 12, 
                  ),
                ),
                Text(
                  'Steve Lin',
                  style: typography.homeUserName.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

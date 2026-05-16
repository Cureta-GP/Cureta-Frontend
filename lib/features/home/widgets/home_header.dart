import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.homeWelcomeBack,
                style: typography.homeWelcomeBack.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              Text(
                '', // Replace with real name later
                style: typography.homeUserName.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: colors.secondary,
            child: Icon(Icons.person_outline, color: colors.primary),
          ),
        ],
      ),
    );
  }
}

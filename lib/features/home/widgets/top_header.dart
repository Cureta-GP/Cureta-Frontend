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
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      child: Row(
        children: [
          // User Avatar with a subtle border
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colors.secondary.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 24, // Slightly larger for better presence
              backgroundColor: colors.secondary,
              child: Icon(
                Icons.person_outline,
                color: colors.primary,
                size: 28,
              ),
            ),
          ),

          SizedBox(width: spacing.sm), // Essential breathing room
          // Text Column
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
                  ),
                ),
                Text(
                  'Name',
                  style: typography.homeUserName.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold, // Stronger visual anchor
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

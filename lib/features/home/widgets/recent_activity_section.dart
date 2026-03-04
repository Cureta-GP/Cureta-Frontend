import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.md),
          child: Text(
            AppLocalizations.homeRecentActivity,
            style: typography.homeSectionTitle.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: spacing.md),
        _ActivityItem(
          title: AppLocalizations.homeBloodTestResults,
          subtitle: AppLocalizations.homeAddedYesterday,
          icon: Icons.biotech_outlined,
          color: colors.accentBlue,
          iconColor: Colors.blue,
        ),
        _ActivityItem(
          title: AppLocalizations.homeVaccinationRecord,
          subtitle: AppLocalizations.homeAddedDaysAgo(3),
          icon: Icons.vaccines_outlined,
          color: colors.accentPurple,
          iconColor: Colors.purple,
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color iconColor;

  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;
    final radius = context.radius;

    return Padding(
      padding: EdgeInsets.only(
        left: spacing.md,
        right: spacing.md,
        bottom: spacing.sm,
      ),
      child: Container(
        padding: EdgeInsets.all(spacing.md),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(radius.lg),
          border: Border.all(color: colors.divider),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(spacing.sm),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(radius.md),
              ),
              child: Icon(icon, color: iconColor),
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: typography.homeActivityName.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: typography.homeActivityDate.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colors.textSecondary),
          ],
        ),
      ),
    );
  }
}

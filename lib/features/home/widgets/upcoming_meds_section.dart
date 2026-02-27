import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';

class UpcomingMedsSection extends StatelessWidget {
  const UpcomingMedsSection({super.key});

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.homeUpcomingMeds,
                style: typography.homeSectionTitle.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  AppLocalizations.homeSeeAll,
                  style: typography.homeSeeAll.copyWith(color: colors.primary),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.sm),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: spacing.md),
            children: [
              _MedCard(
                name: AppLocalizations.homeAmoxicillin,
                note: AppLocalizations.homeAmoxicillinNote,
                time: '08:00 AM',
                icon: Icons.medication_outlined,
              ),
              SizedBox(width: spacing.md),
              _MedCard(
                name: AppLocalizations.homeVitaminD,
                note: AppLocalizations.homeVitaminDNote,
                time: '12:00 PM',
                icon: Icons.vaccines_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MedCard extends StatelessWidget {
  final String name;
  final String note;
  final String time;
  final IconData icon;

  const _MedCard({
    required this.name,
    required this.note,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;
    final radius = context.radius;

    return Container(
      width: 160,
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius.lg),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: colors.primary),
              Text(
                time,
                style: typography.homeMedTime.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            name,
            style: typography.homeMedName.copyWith(color: colors.textPrimary),
          ),
          Text(
            note,
            style: typography.homeMedNote.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

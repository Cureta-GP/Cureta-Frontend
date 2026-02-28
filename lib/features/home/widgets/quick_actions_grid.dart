import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      padding: EdgeInsets.symmetric(horizontal: spacing.md),
      mainAxisSpacing: spacing.sm,
      crossAxisSpacing: spacing.sm,
      children: [
        _QuickActionCard(
          icon: Icons.add_box_outlined,
          label: AppLocalizations.homeAddRecord,
          onTap: () {
            Nav.pushNamed(context, AppRoutes.medicalRecordsStepOne);
          },
        ),
        _QuickActionCard(
          icon: Icons.notifications_none_outlined,
          label: AppLocalizations.homeAddAlert,
          onTap: () {},
        ),
        _QuickActionCard(
          icon: Icons.qr_code_2_outlined,
          label: AppLocalizations.homeMyQrCode,
          onTap: () {},
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;
    final radius = context.radius;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius.md),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(radius.md),
          border: Border.all(color: colors.divider),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: colors.primary, size: 28),
            SizedBox(height: spacing.xs),
            Text(
              label,
              textAlign: TextAlign.center,
              style: typography.homeQuickActionLabel.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
    final colors = context.colors;
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
          onTap: () => Nav.pushNamed(context, AppRoutes.medicalRecordsStepOne),
          baseColor: const Color(0xFF00A3AD),
          circleColor: colors.primary,
        ),
        _QuickActionCard(
          icon: Icons.notifications_none_outlined,
          label: AppLocalizations.homeAddAlert,
          onTap: () {},
          baseColor: const Color(0xFFFF8C00),
          circleColor: const Color(0xFFF97316), 
        ),
        _QuickActionCard(
          icon: Icons.qr_code_2_outlined,
          label: AppLocalizations.homeMyQrCode,
          onTap: () {},
          baseColor: const Color(0xFF007AFF),
          circleColor: Color(0xff6366F1), 
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color baseColor;
  final Color circleColor;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.baseColor,
    required this.circleColor,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = baseColor.withOpacity(0.12);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Container(
        width: 112,
        height: 112,
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: ShapeDecoration(
                color: circleColor, 
                shape: CircleBorder(),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 8),
            // النص
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: circleColor,
                  fontSize: 12,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                  height: 1.33,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      crossAxisCount: 2,
      childAspectRatio: 1.2, // Provides more vertical space for text labels
      padding: EdgeInsetsDirectional.symmetric(horizontal: spacing.md),
      mainAxisSpacing: spacing.sm,
      crossAxisSpacing: spacing.sm,
      children: [
        _QuickActionCard(
          icon: Icons.add_box_outlined,
          label: AppLocalizations.homeAddRecord,
          onTap: () => Nav.pushNamed(context, AppRoutes.medicalRecordsStepOne),
          backgroundColor: colors.accentCyan,
          foregroundColor: colors.primary,
        ),
        _QuickActionCard(
          icon: Icons.qr_code_2_outlined,
          label: AppLocalizations.homeMyQrCode,
          onTap: () {},
          backgroundColor: colors.accentPurple,
          foregroundColor: const Color(0xFF6366F1),
        ),

        _QuickActionCard(
          icon: Icons.document_scanner_outlined,
          label: AppLocalizations.homeScanPrescription,
          onTap: () => Nav.pushNamed(context, AppRoutes.scanPrescription),
          backgroundColor: colors.accentBlue,
          foregroundColor: const Color(0xFF4338CA),
        ),
        _QuickActionCard(
          icon: Icons.notifications_none_outlined,
          label: AppLocalizations.homeAddAlert,
          onTap: () {},
          backgroundColor: colors.accentOrange,
          foregroundColor: const Color(0xFFF97316),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.radius.xl),
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          vertical: context.spacing.md,
          horizontal: context.spacing.md,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(context.radius.xl),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔵 Icon Circle
            Container(
              width: 46, // Reduced size to fit in narrow columns
              height: 46,
              decoration: BoxDecoration(
                color: foregroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: context.spacing.xl),
            ),

            SizedBox(height: context.spacing.sm), // Tighter spacing
            // 📝 Text
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.typography.homeQuickActionLabel.copyWith(
                color: foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

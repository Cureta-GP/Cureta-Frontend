import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';

class MedicineBottomNavBarWidget extends StatelessWidget {
  const MedicineBottomNavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.background,
        border: Border(
          top: BorderSide(
            color: context.colors.divider,
            width: context.spacing.hairline,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_buildIndicator(context), _buildNavItems(context)],
        ),
      ),
    );
  }

  Widget _buildIndicator(BuildContext context) {
    return Container(
      height: context.spacing.xs / 2,
      decoration: BoxDecoration(
        color: context.colors.divider,
        borderRadius: BorderRadius.circular(context.radius.full),
      ),
    );
  }

  Widget _buildNavItems(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: context.spacing.lg,
        vertical: context.spacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            icon: Icons.home,
            label: 'medical_records.list.nav_home'.tr(),
            index: 0,
          ),
          _buildNavItem(
            context,
            icon: Icons.medication,
            label: 'medicines.my_medicines'.tr(),
            index: 1,
          ),
          _buildNavItem(
            context,
            icon: Icons.qr_code_scanner,
            label: 'medical_records.list.nav_scan_rx'.tr(),
            index: 2,
          ),
          _buildNavItem(
            context,
            icon: Icons.description,
            label: 'medical_records.list.nav_records'.tr(),
            index: 3,
          ),
          _buildNavItem(
            context,
            icon: Icons.person,
            label: 'medical_records.list.nav_profile'.tr(),
            index: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(context.radius.md),
      onTap: () => onTap(index),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.md,
          vertical: context.spacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? context.colors.primary : context.colors.icon,
              size: 24,
            ),
            SizedBox(height: context.spacing.xs / 2),
            Text(
              label,
              style: context.typography.medicalRecordProgress.copyWith(
                color: isSelected
                    ? context.colors.primary
                    : context.colors.icon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

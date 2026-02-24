import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class UserRecordsBottomNavigation extends StatelessWidget {
  const UserRecordsBottomNavigation({
    super.key,
    required this.homeLabel,
    required this.medsLabel,
    required this.scanRxLabel,
    required this.recordsLabel,
    required this.profileLabel,
    this.currentIndex = 2,
    this.onItemSelected,
    this.onHomePressed,
    this.onMedsPressed,
    this.onScanRxPressed,
    this.onRecordsPressed,
    this.onProfilePressed,
  });

  final String homeLabel;
  final String medsLabel;
  final String scanRxLabel;
  final String recordsLabel;
  final String profileLabel;
  final int currentIndex;
  final ValueChanged<int>? onItemSelected;
  final VoidCallback? onHomePressed;
  final VoidCallback? onMedsPressed;
  final VoidCallback? onScanRxPressed;
  final VoidCallback? onRecordsPressed;
  final VoidCallback? onProfilePressed;

  void _handleTap(int index) {
    onItemSelected?.call(index);
    switch (index) {
      case 0:
        onHomePressed?.call();
        break;
      case 1:
        onMedsPressed?.call();
        break;
      case 2:
        onRecordsPressed?.call();
        break;
      case 3:
        onProfilePressed?.call();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    final icons = <IconData>[
      Icons.home,
      Icons.medication,
      Icons.description,
      Icons.person,
    ];

    final labels = <String>[homeLabel, medsLabel, recordsLabel, profileLabel];

    return SafeArea(
      top: false,
      child: AnimatedBottomNavigationBar.builder(
        itemCount: icons.length,
        activeIndex: currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: spacing.lg,
        rightCornerRadius: spacing.lg,
        height: spacing.xxl * 2 + spacing.lg,
        backgroundColor: colors.medicalRecordCard,
        splashColor: colors.primary,
        onTap: _handleTap,
        tabBuilder: (index, isActive) {
          final fg = isActive ? colors.primary : colors.medicalRecordMuted;
          return AnimatedScale(
            duration: const Duration(milliseconds: 180),
            scale: isActive ? 1.05 : 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icons[index],
                  size: spacing.xl + spacing.xs / 2,
                  color: fg,
                ),
                SizedBox(height: spacing.xs / 2),
                SizedBox(
                  width: spacing.xxl + spacing.lg,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      labels[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: typography.medicalRecordProgress.copyWith(
                        color: fg,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

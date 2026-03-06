import 'package:cureta/features/home/widgets/select_profile_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';

class TopHeader extends StatelessWidget {
  final String userName;
  const TopHeader({super.key, required this.userName});

  // دالة لإظهار قائمة البروفايلات
  void _showProfileSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SelectProfileBottomSheet(), // الويدجت اللي هنبنيها تحت
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.sm),
      child: InkWell( // جعل المنطقة قابلة للضغط
        onTap: () => _showProfileSelector(context),
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
                      fontSize: 12,
                    ),
                  ),
                  Row( // إضافة سهم صغير بجانب الاسم ليوحي بأنه قابل للضغط
                    children: [
                      Text(
                        userName,
                        style: typography.homeUserName.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: colors.textPrimary, size: 20),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
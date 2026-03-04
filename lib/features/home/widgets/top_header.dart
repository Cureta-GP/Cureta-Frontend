import 'package:cureta/features/profile/model/profile_model.dart';
import 'package:cureta/features/profile/view/select_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';

class TopHeader extends StatelessWidget {
  final List<ProfileModel> profiles;
  final String selectedProfileId;
  final VoidCallback onAddProfilePressed;
  final ValueChanged<ProfileModel> onProfileSelected;

  const TopHeader({
    super.key,
    required this.profiles,
    required this.selectedProfileId,
    required this.onAddProfilePressed,
    required this.onProfileSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm, 
        vertical: spacing.sm,
      ),
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
                    height: 1.2,
                    fontSize: 12,
                  ),
                ),

                GestureDetector(
                  onTap: () async {
                    final selected = await SelectProfileScreen.showAsBottomSheet(
                      context,
                      profiles: profiles,
                      selectedProfileId: selectedProfileId,
                      onAddProfilePressed: onAddProfilePressed,
                    );

                    if (selected != null) {
                      onProfileSelected(selected);
                    }
                  },
                  child: Text(
                    'Steve Lin',
                    style: typography.homeUserName.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline, 
                    ),
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
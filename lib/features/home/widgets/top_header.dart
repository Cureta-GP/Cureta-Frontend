<<<<<<< HEAD
import 'package:cureta/features/home/widgets/select_profile_bottom_sheet.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
=======
import 'package:cureta/features/profile/model/profile_model.dart';
import 'package:cureta/features/profile/view/select_profile_screen.dart';
>>>>>>> temp
import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopHeader extends StatelessWidget {
<<<<<<< HEAD
  final String userName;
  const TopHeader({super.key, required this.userName});

  void _showProfileSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (innerContext) => BlocProvider.value(
      value: BlocProvider.of<ProfilesListCubit>(context),
      child: const SelectProfileBottomSheet(),
    ), 
    );
  }
=======
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
>>>>>>> temp

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;

    return Padding(
<<<<<<< HEAD
      padding: EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.sm),
      child: InkWell( 
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
                  Row( 
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
=======
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
>>>>>>> temp
            ),
          ],
        ),
      ),
    );
  }
}
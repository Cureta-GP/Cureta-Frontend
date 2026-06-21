import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/profile/data/models/profile_model.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_state.dart';
import 'package:cureta/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SelectProfileBottomSheet extends StatelessWidget {
  const SelectProfileBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final maxHeight = MediaQuery.of(context).size.height * 0.75;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          spacing.lg,
          spacing.md,
          spacing.lg,
          spacing.lg + MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: BlocBuilder<ProfilesListCubit, ProfilesListState>(
          builder: (context, state) {
            if (state is ProfilesLoading) {
              return const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is ProfilesError) {
              return SizedBox(
                height: 120,
                child: Center(child: Text(state.message)),
              );
            }

            if (state is ProfilesSuccess) {
              final profiles = state.profiles;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  SizedBox(height: spacing.lg),

                  Text(
                    AppLocalizations.profilesSelectProfileTitle,
                    style: typography.title,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    AppLocalizations.profilesSelectProfileSubtitle,
                    style: typography.body.copyWith(color: colors.textSecondary),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: spacing.lg),

                  // Scrollable profile list
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: profiles.length,
                      itemBuilder: (context, index) => _buildProfileTile(
                        context,
                        profile: profiles[index],
                        isSelected: profiles[index].id == state.selectedProfileId,
                      ),
                    ),
                  ),

                  SizedBox(height: spacing.lg),

                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: AppLocalizations.profilesAddNewProfile,
                      onPressed: () {
                        final cubit = context.read<ProfilesListCubit>();
                        GoRouter.of(context)
                            .pushNamed(AppRoutes.addProfile, extra: true)
                            .then((_) {
                          cubit.getProfiles();
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildProfileTile(
    BuildContext context, {
    required ProfileModel profile,
    bool isSelected = false,
  }) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected
            ? colors.primary.withValues(alpha: 0.05)
            : Colors.transparent,
        border: Border.all(color: isSelected ? colors.primary : colors.divider),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: () {
          context.read<ProfilesListCubit>().selectProfile(profile.id);
          Navigator.pop(context);
        },
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundImage: profile.imageUrl != null
              ? NetworkImage(profile.imageUrl!)
              : null,
          child: profile.imageUrl == null ? Text(profile.fullName[0]) : null,
        ),
        title: Text(
          profile.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(AppLocalizations.getLocalizedRelationship(profile.relationship)),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: colors.primary)
            : const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

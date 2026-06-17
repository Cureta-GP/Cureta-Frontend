import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:cureta/features/profile/view/select_profile_screen.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_state.dart';
import 'package:cureta/features/profile/widgets/selected_profile_card.dart';
import 'package:cureta/features/profile/widgets/switch_profile_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AllProfiesView extends StatefulWidget {
  const AllProfiesView({super.key});

  @override
  State<AllProfiesView> createState() => _AllProfiesViewState();
}

class _AllProfiesViewState extends State<AllProfiesView> {
  Future<void> _showProfileSelectionDialog(ProfilesSuccess state) async {
    if (state.profiles.isEmpty) {
      return;
    }

    final selected = await SelectProfileScreen.showAsDialog(
      context,
      profiles: state.profiles,
      selectedProfileId: state.selectedProfileId ?? state.profiles.first.id,
      onAddProfilePressed: _onAddProfilePressed,
    );

    if (selected != null && mounted) {
      context.read<ProfilesListCubit>().selectProfile(selected.id);
    }
  }

  void _onAddProfilePressed() {
    Navigator.of(context).pop();
    final cubit = context.read<ProfilesListCubit>();
    GoRouter.of(context).pushNamed(AppRoutes.addProfile, extra: true).then((_) {
      cubit.getProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;
    final typography = context.typography;
    final radius = context.radius;

    return BlocProvider(
      create: (context) =>
          ProfilesListCubit(getIt.get<ProfileRepository>())..getProfiles(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colors.background,
          elevation: 0,
          title: Text(
            'Family Profiles',
            style: typography.title.copyWith(color: colors.textPrimary),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<ProfilesListCubit, ProfilesListState>(
            builder: (context, state) {
              if (state is ProfilesLoading || state is ProfilesInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfilesError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(spacing.lg),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: typography.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                );
              }

              if (state is ProfilesSuccess) {
                if (state.profiles.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(spacing.lg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'No profiles found',
                            style: typography.title.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: spacing.md),
                          ElevatedButton(
                            onPressed: _onAddProfilePressed,
                            child: const Text('Add Profile'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final selectedId =
                    state.selectedProfileId ?? state.profiles.first.id;
                final currentProfile = state.profiles.firstWhere(
                  (p) => p.id == selectedId,
                  orElse: () => state.profiles.first,
                );

                return Padding(
                  padding: EdgeInsets.all(spacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Profile',
                        style: typography.label.copyWith(
                          color: colors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: spacing.md),
                      SelectedProfileCard(
                        profile: currentProfile,
                        onTap: () => _showProfileSelectionDialog(state),
                        accentColor: colors.accentCyan,
                        borderColor: colors.primary,
                        textColor: colors.textPrimary,
                        secondaryTextColor: colors.textSecondary,
                        primaryColor: colors.primary,
                        borderRadius: radius.md,
                        avatarSize: spacing.xxl + spacing.lg,
                        titleStyle: typography.title,
                        bodyStyle: typography.body,
                      ),
                      SizedBox(height: spacing.xl),
                      SwitchProfileButton(
                        onPressed: () => _showProfileSelectionDialog(state),
                        backgroundColor: colors.primary,
                        foregroundColor: Colors.white,
                        borderRadius: radius.md,
                        minHeight: spacing.xxl + spacing.lg,
                        paddingVertical: spacing.md,
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
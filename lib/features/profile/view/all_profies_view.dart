import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/profile/data/models/profile_model.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:cureta/features/profile/view/select_profile_screen.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_state.dart';
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
    GoRouter.of(context).go(AppRoutes.addProfile, extra: true);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;
    final typography = context.typography;

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

                      _buildSelectedProfileCard(
                        context,
                        profile: currentProfile,
                        onTap: () => _showProfileSelectionDialog(state),
                      ),
                      SizedBox(height: spacing.xl),

                      _buildSwitchProfileButton(
                        context,
                        onPressed: () => _showProfileSelectionDialog(state),
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

  Widget _buildSelectedProfileCard(
    BuildContext context, {
    required ProfileModel profile,
    required VoidCallback onTap,
  }) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final radius = context.radius;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: colors.accentCyan,
          borderRadius: BorderRadius.circular(radius.md),
          border: Border.all(color: colors.primary, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: spacing.xxl + spacing.lg,
              height: spacing.xxl + spacing.lg,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _getInitials(profile.fullName),
                  style: typography.title.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: spacing.lg),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.fullName,
                    style: typography.title.copyWith(color: colors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    profile.relationship,
                    style: typography.body.copyWith(
                      color: colors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              color: colors.primary,
              size: spacing.lg,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchProfileButton(
    BuildContext context, {
    required VoidCallback onPressed,
  }) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;

    return SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: spacing.xxl + spacing.lg),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.swap_horiz),
          label: const Text('Switch Profile'),
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.md),
            ),
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: spacing.md),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return '?';
    final initials = parts.take(2).map((e) => e.isNotEmpty ? e[0] : '').join();
    return initials.toUpperCase();
  }
}

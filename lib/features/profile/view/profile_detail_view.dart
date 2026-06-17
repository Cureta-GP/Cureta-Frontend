import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/profile/data/models/profile_model.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_state.dart';
import 'package:cureta/features/profile/widgets/profile_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.profilesDetailsTitle),
        backgroundColor: colors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<ProfilesListCubit, ProfilesListState>(
        builder: (context, state) {
          if (state is! ProfilesSuccess) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = state.profiles.firstWhere(
            (p) => p.id == state.selectedProfileId,
            orElse: () => state.profiles.first,
          );
          final repository = context.read<ProfilesListCubit>().repository;

          return SingleChildScrollView(
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              children: [
                _buildProfileHeader(profile, colors),
                SizedBox(height: spacing.xl),
                ..._buildProfileCards(profile),
                SizedBox(height: spacing.xxl),
                _buildActionButtons(context, profile, repository),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(ProfileModel profile, dynamic colors) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: colors.primary.withValues(alpha: 0.1),
            backgroundImage: profile.imageUrl != null
                ? NetworkImage(profile.imageUrl!)
                : null,
            child: profile.imageUrl == null
                ? Text(
                    profile.fullName.isNotEmpty ? profile.fullName[0] : '',
                    style: const TextStyle(fontSize: 40),
                  )
                : null,
          ),
          if (!profile.isPrimary)
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                backgroundColor: colors.primary,
                radius: 18,
                child: const Icon(Icons.edit, color: Colors.white, size: 18),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildProfileCards(ProfileModel profile) {
    final cards = <Widget>[
      ProfileDetailCard(
        icon: Icons.person_outline,
        label: 'Full Name',
        value: profile.fullName,
      ),
      if (profile.relationship.isNotEmpty)
        ProfileDetailCard(
          icon: Icons.family_restroom,
          label: 'Relationship',
          value: profile.relationship,
        ),
      ProfileDetailCard(
        icon: Icons.cake_outlined,
        label: 'Age',
        value: '${profile.age} Years',
      ),
      ProfileDetailCard(
        icon: profile.gender == 'Male' ? Icons.male : Icons.female,
        label: 'Gender',
        value: profile.gender,
      ),
      ProfileDetailCard(
        icon: Icons.bloodtype,
        label: 'Blood Type',
        value: profile.bloodType,
      ),
      ProfileDetailCard(
        icon: Icons.health_and_safety,
        label: 'Chronic Conditions',
        items: _extractDisplayItems(profile.chronicDiseases),
      ),
      ProfileDetailCard(
        icon: Icons.set_meal,
        label: 'Allergies',
        items: _extractDisplayItems(profile.allergies),
      ),
    ];

    return cards;
  }

  Widget _buildActionButtons(
    BuildContext context,
    ProfileModel profile,
    ProfileRepository repository,
  ) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            final result = await GoRouter.of(
              context,
            ).push(AppRoutes.addProfile, extra: profile);
            if (!context.mounted) return;
            if (result is ProfileModel) {
              context.read<ProfilesListCubit>().getProfiles();
            }
          },
          child: Text(
            AppLocalizations.profilesEditProfile,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(height: spacing.md),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: profile.isPrimary ? colors.divider : colors.error,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: profile.isPrimary
              ? null
              : () => _deleteProfile(context, profile, repository),
          child: Text(
            profile.isPrimary
                ? AppLocalizations.profilesCannotDelete
                : AppLocalizations.profilesDeleteProfile,
            style: TextStyle(
              color: profile.isPrimary ? colors.divider : colors.error,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _deleteProfile(
    BuildContext context,
    ProfileModel profile,
    ProfileRepository repository,
  ) async {
    final confirmed = await _showDeleteConfirmationDialog(context);
    if (confirmed != true || !context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await repository.deleteProfile(profileId: profile.id);
      if (!context.mounted) return;
      await context.read<ProfilesListCubit>().getProfiles();
      if (!context.mounted) return;
      Navigator.pop(context);
      _showSnackBar(context, AppLocalizations.profilesDetailsDeleteSuccess);
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      _showSnackBar(
        context,
        AppLocalizations.profilesDetailsDeleteFailed(e.toString()),
      );
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.profilesDetailsDeleteConfirmTitle),
        content: Text(AppLocalizations.profilesDetailsDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.profilesDetailsCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.profilesDetailsDelete),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  List<String> _extractDisplayItems(List<dynamic> items) {
    if (items.isEmpty) return const ['None'];
    return items
        .map((item) {
          if (item is Map<String, dynamic>) {
            final val = item['description'] ?? item['name'];
            return val?.toString() ?? item.toString();
          }
          return item.toString();
        })
        .where((text) => text.trim().isNotEmpty)
        .toList();
  }

  // Removed _buildDetailCard, now using ProfileDetailCard widget
}

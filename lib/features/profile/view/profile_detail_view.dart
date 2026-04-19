import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/profile/data/models/profile_model.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_state.dart';
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
        title: const Text("Profile Details"),
        backgroundColor: colors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<ProfilesListCubit, ProfilesListState>(
        builder: (context, state) {
          if (state is ProfilesSuccess) {
            final profile = state.profiles.firstWhere(
              (p) => p.id == state.selectedProfileId,
              orElse: () => state.profiles.first,
            );
            final repository = context.read<ProfilesListCubit>().repository;

            return SingleChildScrollView(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                children: [
                  Center(
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
                                  profile.fullName[0],
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
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacing.xl),

                  _buildDetailCard(
                    context,
                    icon: Icons.person_outline,
                    label: "Full Name",
                    value: profile.fullName,
                  ),
                  if (profile.relationship.isNotEmpty)
                    _buildDetailCard(
                      context,
                      icon: Icons.family_restroom,
                      label: "Relationship",
                      value: profile.relationship,
                    ),
                  _buildDetailCard(
                    context,
                    icon: Icons.cake_outlined,
                    label: "Age",
                    value: "${profile.age} Years",
                  ),
                  _buildDetailCard(
                    context,

    icon: profile.gender == "Male" ? Icons.male : Icons.female,
                    label: "Gender",
                    value: profile.gender,
                  ),
                  _buildDetailCard(
                    context,
                    icon: Icons.bloodtype,
                    label: "Blood Type",
                    value: profile.bloodType,
                  ),
                /*  _buildDetailCard(
                    context,
                    icon: Icons.event,
                    label: "Created At",
                    value: profile.createdAt,
                  ),*/
                  _buildDetailCard(
                    context,
                    icon: Icons.health_and_safety,
                    label: "Chronic Conditions",
                    value: _listToDisplay(profile.chronicDiseases),
                  ),
                  _buildDetailCard(
                    context,
                    icon: Icons.set_meal,
                    label: "Allergies",
                    value: _listToDisplay(profile.allergies),
                  ),
                  SizedBox(height: spacing.xxl),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            final result = await GoRouter.of(context)
                                .push(AppRoutes.addProfile, extra: profile);
                            if (!context.mounted) return;
                            if (result is ProfileModel) {
                              context.read<ProfilesListCubit>().getProfiles();
                            }
                          },
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.md),
                      Expanded(
                        child: OutlinedButton(
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
                              : () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Profile'),
                                content: const Text(
                                  'Are you sure you want to delete this profile?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed != true) return;
                            if (!context.mounted) return;

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            try {
                              await repository.deleteProfile(
                                profileId: profile.id,
                              );
                              if (!context.mounted) return;
                              await context
                                  .read<ProfilesListCubit>()
                                  .getProfiles();
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Profile deleted successfully.',
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Delete failed: $e')),
                              );
                            }
                          },
                          child: Text(
                            profile.isPrimary ? 'Cannot Delete' : 'Delete',
                            style: TextStyle(
                              color: profile.isPrimary ? colors.divider : colors.error,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  String _listToDisplay(List<dynamic> items) {
    if (items.isEmpty) return 'None';
    return items
        .map((item) {
          if (item is Map<String, dynamic>) {
            final val = item['description'] ?? item['name'];
            return val?.toString() ?? item.toString();
          }
          return item.toString();
        })
        .join(', ');
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.background, // تأكدي من وجودها في الـ theme_extensions
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.divider.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: colors.primary),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

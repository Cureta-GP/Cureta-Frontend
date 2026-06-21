import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/profile/widgets/profile_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/profile/data/models/profile_model.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_state.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/features/medical_records/widgets/user_records_header.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            UserRecordsHeader(title: AppLocalizations.profilesDetailsTitle),
            Expanded(
              child: BlocBuilder<ProfilesListCubit, ProfilesListState>(
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
                          backgroundColor: colors.primary,
                          backgroundImage: profile.imageUrl != null
                              ? NetworkImage(profile.imageUrl!)
                              : null,
                          child: profile.imageUrl == null
                              ? Text(
                                  profile.fullName[0],
                                  style: const TextStyle(fontSize: 40, color: Colors.white),
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

                  ProfileDetailCard(
                    icon: Icons.person_outline,
                    label: AppLocalizations.profilesDetailsFullName,
                    value: profile.fullName,
                  ),
                  if (profile.relationship.isNotEmpty)
                    ProfileDetailCard(
                      icon: Icons.family_restroom,
                      label: AppLocalizations.profilesDetailsRelationship,
                      value: AppLocalizations.getLocalizedRelationship(profile.relationship),
                    ),
                  ProfileDetailCard(
                    icon: Icons.cake_outlined,
                    label: AppLocalizations.profilesDetailsAge,
                    value: "${profile.age} ${AppLocalizations.profilesDetailsYears}",
                  ),
                  ProfileDetailCard(
                    icon: profile.gender == "Male" ? Icons.male : Icons.female,
                    label: AppLocalizations.profilesDetailsGender,
                    value: AppLocalizations.getLocalizedGender(profile.gender),
                  ),
                  ProfileDetailCard(
                    icon: Icons.bloodtype,
                    label: AppLocalizations.profilesDetailsBloodType,
                    value: profile.bloodType,
                  ),
                  /*ProfileDetailCard(
                    icon: Icons.event,
                    label: "Created At",
                    value: profile.createdAt,
                  ),*/
                  ProfileDetailCard(
                    icon: Icons.health_and_safety,
                    label: AppLocalizations.profilesDetailsChronicConditions,
                    items: _extractDisplayItems(profile.chronicDiseases),
                  ),
                  ProfileDetailCard(
                    icon: Icons.set_meal,
                    label: AppLocalizations.profilesDetailsAllergies,
                    items: _extractDisplayItems(profile.allergies),
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
                      ),
                      SizedBox(width: spacing.md),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: profile.isPrimary
                                  ? colors.divider
                                  : colors.error,
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
                                      title: Text(AppLocalizations.profilesDetailsDeleteConfirmTitle),
                                      content: Text(
                                        AppLocalizations.profilesDetailsDeleteConfirmMessage,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text(AppLocalizations.profilesDetailsCancel),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text(AppLocalizations.profilesDetailsDelete),
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
                                      SnackBar(
                                        content: Text(
                                          AppLocalizations.profilesDetailsDeleteSuccess,
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          AppLocalizations.profilesDetailsDeleteFailed(e.toString()),
                                        ),
                                      ),
                                    );
                                  }
                                },
                          child: Text(
                            profile.isPrimary
                                ? AppLocalizations.profilesCannotDelete
                                : AppLocalizations.profilesDeleteProfile,
                            style: TextStyle(
                              color: profile.isPrimary
                                  ? colors.divider
                                  : colors.error,
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
            ),
          ],
        ),
      ),
    );
  }

  List<String> _extractDisplayItems(List<dynamic> items) {
    if (items.isEmpty) return [AppLocalizations.commonNone];
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
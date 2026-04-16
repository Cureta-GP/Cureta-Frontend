import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_state.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

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

            return SingleChildScrollView(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: colors.primary.withOpacity(0.1),
                          backgroundImage: profile.imageUrl != null 
                              ? NetworkImage(profile.imageUrl!) 
                              : null,
                          child: profile.imageUrl == null 
                              ? Text(profile.fullName[0], style: const TextStyle(fontSize: 40)) 
                              : null,
                        ),
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
                  ),
                  SizedBox(height: spacing.xl),

                  _buildDetailCard(
                    context,
                    icon: Icons.person_outline,
                    label: "Full Name",
                    value: profile.fullName,
                  ),
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
                  
                  SizedBox(height: spacing.xxl),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        // Navigate to edit screen
                      },
                      child: const Text("Edit Profile Information", style: TextStyle(color: Colors.white)),
                    ),
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

  Widget _buildDetailCard(BuildContext context, {required IconData icon, required String label, required String value}) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.background, // تأكدي من وجودها في الـ theme_extensions
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.divider.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: colors.primary),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
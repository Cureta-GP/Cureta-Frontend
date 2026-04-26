import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/home/widgets/quick_actions_grid.dart';
import 'package:cureta/features/home/widgets/upcoming_meds_section.dart';
import 'package:cureta/features/home/widgets/recent_activity_section.dart';
import 'package:cureta/features/home/widgets/top_header.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_state.dart';

class HomeView extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const HomeView({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: onMenuPressed,
          icon: Icon(
            Icons.menu,
            size: spacing.xl + spacing.sm,
            color: colors.textPrimary,
          ),
        ),
        title: BlocBuilder<ProfilesListCubit, ProfilesListState>(
          builder: (context, state) {
            var name = 'Loading...';

            if (state is ProfilesSuccess && state.profiles.isNotEmpty) {
              final currentSelectedId =
                  state.selectedProfileId ?? state.profiles.first.id;
              final selectedProfile = state.profiles.firstWhere(
                (p) => p.id == currentSelectedId,
                orElse: () => state.profiles.first,
              );
              name = selectedProfile.fullName;
            }

            return TopHeader(userName: name);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: spacing.lg),
              const QuickActionsGrid(),
              SizedBox(height: spacing.xl),
              const UpcomingMedsSection(),
              SizedBox(height: spacing.xl),

              const RecentActivitySection(),
              SizedBox(height: spacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

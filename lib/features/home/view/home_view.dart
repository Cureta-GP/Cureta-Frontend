import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/home/view_model/home_schedule_cubit.dart';
import 'package:cureta/features/home/view_model/home_schedule_state.dart';
import 'package:cureta/features/home/widgets/quick_actions_grid.dart';
import 'package:cureta/features/home/widgets/recent_activity_section.dart';
import 'package:cureta/features/home/widgets/today_stats_row.dart';
import 'package:cureta/features/home/widgets/top_header.dart';
import 'package:cureta/features/home/widgets/upcoming_meds_section.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.onMenuPressed});

  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return BlocProvider(
      create: (_) => getIt<HomeScheduleCubit>(),
      child: BlocListener<ProfilesListCubit, ProfilesListState>(
        // Fires every time profiles state changes
        listener: (context, profileState) {
          final profileId = _resolveProfileId(profileState);
          if (profileId == null) return;

          // Start auto-refresh from medicines stream for live home updates.
          context.read<HomeScheduleCubit>().startAutoRefresh(profileId);
        },
        // Also trigger immediately if profiles already loaded
        listenWhen: (_, current) => current is ProfilesSuccess,
        child: BlocBuilder<ProfilesListCubit, ProfilesListState>(
          builder: (context, profileState) {
            final profileId = _resolveProfileId(profileState);
            final userName = _resolveUserName(profileState);

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
                title: TopHeader(userName: userName),
              ),
              body: SafeArea(
                child: BlocListener<HomeScheduleCubit, HomeScheduleState>(
                  listener: (context, state) {
                    if (state is HomeScheduleError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: colors.error,
                        ),
                      );
                    }
                  },
                  child: RefreshIndicator(
                    color: colors.primary,
                    onRefresh: () async {
                      if (profileId != null) {
                        await context.read<HomeScheduleCubit>().refresh(
                          profileId,
                        );
                      }
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: spacing.lg),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing.lg,
                            ),
                            child: const TodayStatsRow(),
                          ),

                          SizedBox(height: spacing.xl),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing.lg,
                            ),
                            child: const UpcomingMedsSection(),
                          ),
                          SizedBox(height: spacing.xl),
                          const QuickActionsGrid(),
                          SizedBox(height: spacing.xl),
                          const RecentActivitySection(),
                          SizedBox(height: spacing.xxl),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String? _resolveProfileId(ProfilesListState state) {
    if (state is! ProfilesSuccess || state.profiles.isEmpty) return null;
    return state.selectedProfileId ?? state.profiles.first.id;
  }

  String _resolveUserName(ProfilesListState state) {
    if (state is! ProfilesSuccess || state.profiles.isEmpty) return '...';
    final id = state.selectedProfileId ?? state.profiles.first.id;
    return state.profiles
        .firstWhere((p) => p.id == id, orElse: () => state.profiles.first)
        .fullName;
  }
}

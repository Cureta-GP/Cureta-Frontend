import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/home/widgets/home_header.dart';
import 'package:cureta/features/home/widgets/quick_actions_grid.dart';
import 'package:cureta/features/home/widgets/upcoming_meds_section.dart';
import 'package:cureta/features/home/widgets/recent_activity_section.dart';
import 'package:cureta/features/medical_records/widgets/user_records_bottom_navigation.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: spacing.md),
              const HomeHeader(),
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

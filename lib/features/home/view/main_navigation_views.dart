import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import "package:cureta/features/medical_records/veiw/User's_Records.dart";
import 'package:cureta/features/medical_records/widgets/user_records_bottom_navigation.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:cureta/features/profile/view/profile_detail_view.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_state.dart';
import 'package:cureta/features/profile/view_model/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/Meds/view/medicines_main_view.dart';
import 'package:cureta/features/home/view/home_view.dart';
import 'package:cureta/features/home/widgets/custom_drawer.dart';
import 'package:cureta/features/home/widgets/top_header.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainNavigationScreen extends StatefulWidget {
  final ProfileState profile;
  const MainNavigationScreen({super.key, required this.profile});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final _advancedDrawerController = AdvancedDrawerController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return BlocProvider(
      create: (context) =>
          ProfilesListCubit(getIt.get<ProfileRepository>())..getProfiles(),
      child: AdvancedDrawer(
        backdrop: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: colors.primary),
        ),
        controller: _advancedDrawerController,
        drawer: CustomDrawer(controller: _advancedDrawerController),
        child: Scaffold(
          backgroundColor: colors.background,
          appBar: AppBar(
            backgroundColor: colors.background,
            scrolledUnderElevation: 0,
            elevation: 0,
            centerTitle: false,
            titleSpacing: 0,
            leading: IconButton(
              onPressed: _handleMenuButtonPressed,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: _advancedDrawerController,
                builder: (context, value, child) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      size: spacing.xl + spacing.sm,
                      key: ValueKey<bool>(value.visible),
                      color: colors.textPrimary,
                    ),
                  );
                },
              ),
            ),
            title: BlocBuilder<ProfilesListCubit, ProfilesListState>(
              builder: (context, state) {
                String name = "Loading...";
                if (state is ProfilesSuccess) {
                  final selectedProfile = state.profiles.firstWhere(
                    (p) => p.id == state.selectedProfileId,
                    orElse: () => state.profiles.first,
                  );
                  name = selectedProfile.fullName;
                }
                return TopHeader(userName: name);
              },
            ),
          ),
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              const HomeView(),
              const MedicinesMainView(),
              UserRecordsView(isActive: _selectedIndex == 2),
              const ProfileDetailsScreen(),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: UserRecordsBottomNavigation(
            currentIndex: _selectedIndex,
            homeLabel: AppLocalizations.recordsListNavHome,
            medsLabel: AppLocalizations.recordsListNavMeds,
            scanRxLabel: AppLocalizations.recordsListNavScanRx,
            recordsLabel: AppLocalizations.recordsListNavRecords,
            profileLabel: AppLocalizations.recordsListNavProfile,
            onHomePressed: () {
              _onItemTapped(0);
            },
            onMedsPressed: () {
              _onItemTapped(1);
            },

            onRecordsPressed: () {
              _onItemTapped(2);
            },
            onProfilePressed: () {
              _onItemTapped(3);
            },
          ),
        ),
      ),
    );
  }
}

import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import "package:cureta/features/medical_records/veiw/User's_Records.dart";
import 'package:cureta/features/medical_records/widgets/user_records_bottom_navigation.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:cureta/features/profile/view/profile_detail_view.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medicines/view/medicines_main_view.dart';
import 'package:cureta/features/home/view/home_view.dart';
import 'package:cureta/features/home/widgets/custom_drawer.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(32)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        drawer: CustomDrawer(controller: _advancedDrawerController),
        child: Scaffold(
          backgroundColor: colors.background,
          // الـ AppBar تم حذفه من هنا ليصبح التحكم لكل صفحة على حدة
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              HomeView(onMenuPressed: _handleMenuButtonPressed), 
              const MedicinesMainView(),
              UserRecordsView(isActive: _selectedIndex == 2),
              const ProfileDetailsScreen(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.pushNamed(AppRoutes.chat);
            },
            child: const Icon(Icons.chat),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: UserRecordsBottomNavigation(
            currentIndex: _selectedIndex,
            homeLabel: AppLocalizations.recordsListNavHome,
            medsLabel: AppLocalizations.recordsListNavMeds,
            scanRxLabel: AppLocalizations.recordsListNavScanRx,
            recordsLabel: AppLocalizations.recordsListNavRecords,
            profileLabel: AppLocalizations.recordsListNavProfile,
            onHomePressed: () => _onItemTapped(0),
            onMedsPressed: () => _onItemTapped(1),
            onRecordsPressed: () => _onItemTapped(2),
            onProfilePressed: () => _onItemTapped(3),
          ),
        ),
      ),
    );
  }
}
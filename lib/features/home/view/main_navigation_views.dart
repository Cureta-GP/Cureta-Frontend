import 'package:cureta/features/medical_records/veiw/User%E2%80%98s_Records.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/Meds/view/medicines_main_view.dart';
import 'package:cureta/features/home/view/home_view.dart';
import 'package:cureta/features/home/widgets/custom_drawer.dart';
import 'package:cureta/features/home/widgets/top_header.dart';
import 'package:cureta/features/medical_records/widgets/user_records_bottom_navigation.dart';
import 'package:cureta/features/profile/view/all_profies_view.dart';
import 'package:cureta/features/profile/model/profile_model.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  final _advancedDrawerController = AdvancedDrawerController();

  List<ProfileModel> profiles = [
    ProfileModel(
      id: '1',
      name: 'Steve Lin',
      relationship: 'Self',
      avatarUrl: '',
    ),
    ProfileModel(
      id: '2',
      name: 'Alice Lin',
      relationship: 'Daughter',
      avatarUrl: '',
    ),
    ProfileModel(id: '3', name: 'Bob Lin', relationship: 'Son', avatarUrl: ''),
  ];

  String selectedProfileId = '1'; 

  final List<Widget> _screens = [
    const HomeView(),
    const MedicinesMainView(),
    const UserRecordsView(),
    const AllProfiesView(),
  ];

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

    return AdvancedDrawer(
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
      drawer: const CustomDrawer(),
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
              builder: (_, value, __) {
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

          title: TopHeader(
            profiles: profiles,
            selectedProfileId: selectedProfileId,
            onAddProfilePressed: () {
              print('Add profile pressed');
            },
            onProfileSelected: (ProfileModel profile) {
              setState(() {
                selectedProfileId = profile.id;
              });
            },
          ),
        ),
        body: IndexedStack(index: _selectedIndex, children: _screens),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: colors.primary,
          child: const Icon(Icons.document_scanner, color: Colors.white),
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
    );
  }
}

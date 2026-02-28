import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/Meds/view/medicines_main_view.dart';
import 'package:cureta/features/home/view/home_view.dart';
import 'package:cureta/features/home/widgets/top_header.dart';
import 'package:cureta/features/medical_records/veiw/User%E2%80%98s_Records.dart';
import 'package:cureta/features/medical_records/widgets/user_records_bottom_navigation.dart';
import 'package:cureta/features/profile/view/all_profies_view.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeView(),
    const MedicinesMainView(),
    // Container(), // Placeholder for Scan Rx
    const UserRecordsView(),
    const AllProfiesView(), // Placeholder for Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.background, 
        scrolledUnderElevation: 0, 
        elevation: 0,
        title: const TopHeader(),
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: colors.homeBotBg,
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
    );
  }
}

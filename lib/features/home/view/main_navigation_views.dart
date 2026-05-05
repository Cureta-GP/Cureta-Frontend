import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/authentcation/veiw_model/auth_view_model.dart';
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
  final int initialTabIndex;

  const MainNavigationScreen({
    super.key,
    required this.profile,
    this.initialTabIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  final _advancedDrawerController = AdvancedDrawerController();

  ({IconData icon, VoidCallback onPressed, String tooltip}) _fabConfig() {
    switch (_selectedIndex) {
      case 1:
        return (
          icon: Icons.medication_rounded,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Add medicine is coming soon')),
            );
          },
          tooltip: 'Add medicine',
        );
      case 2:
        return (
          icon: Icons.note_add_rounded,
          onPressed: () {
            context.pushNamed(AppRoutes.medicalRecordsStepOne);
          },
          tooltip: 'Add record',
        );
      case 3:
        return (
          icon: Icons.person_add_alt_1_rounded,
          onPressed: () {
            context.pushNamed(AppRoutes.addProfile, extra: true);
          },
          tooltip: 'Add profile',
        );
      default:
        return (
          icon: Icons.chat,
          onPressed: () {
            context.pushNamed(AppRoutes.chat);
          },
          tooltip: 'Chat',
        );
    }
  }

  int? _tabFromRoute(BuildContext context) {
    try {
      final tab = int.tryParse(
        GoRouterState.of(context).uri.queryParameters['tab'] ?? '',
      );
      if (tab == null) return null;
      return tab.clamp(0, 3);
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTabIndex.clamp(0, 3);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routedTab = _tabFromRoute(context);
    if (routedTab != null) {
      _selectedIndex = routedTab;
    }
  }

  @override
  void didUpdateWidget(covariant MainNavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTabIndex != widget.initialTabIndex) {
      _selectedIndex = widget.initialTabIndex.clamp(0, 3);
    }
  }

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
    final fabConfig = _fabConfig();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ProfilesListCubit(getIt.get<ProfileRepository>())..getProfiles(),
        ),
        BlocProvider(create: (context) => getIt<AuthCubit>()),
      ],
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
            onPressed: fabConfig.onPressed,
            tooltip: fabConfig.tooltip,
            child: Icon(fabConfig.icon),
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

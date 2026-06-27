import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/Services/notification_service.dart';
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
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/shared/widgets/custom_action_dialog.dart';
import 'package:easy_localization/easy_localization.dart';

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
  late final ProfilesListCubit _profilesCubit;

  Future<void> _openAddMedicine() async {
    await context.pushNamed(AppRoutes.medicinesAddStep1);
  }

  ({IconData icon, void Function(BuildContext) onPressed, String tooltip}) _fabConfig() {
    switch (_selectedIndex) {
      case 1:
        return (
          icon: Icons.medication_rounded,
          onPressed: (innerContext) {
            _openAddMedicine();
          },
          tooltip: 'Add medicine',
        );
      case 2:
        return (
          icon: Icons.note_add_rounded,
          onPressed: (innerContext) {
            innerContext.pushNamed(AppRoutes.medicalRecordsStepOne);
          },
          tooltip: 'Add record',
        );
      case 3:
        return (
          icon: Icons.person_add_alt_1_rounded,
          onPressed: (innerContext) {
            final cubit = innerContext.read<ProfilesListCubit>();
            innerContext.pushNamed(AppRoutes.addProfile, extra: true).then((_) {
              cubit.getProfiles();
            });
          },
          tooltip: 'Add profile',
        );
      default:
        return (
          icon: Icons.chat,
          onPressed: (innerContext) {
            innerContext.pushNamed(AppRoutes.chat);
          },
          tooltip: 'Chat',
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTabIndex.clamp(0, 3);
    _profilesCubit = ProfilesListCubit(getIt.get<ProfileRepository>())..getProfiles();
    _checkAlarmPermissions();
  }

  @override
  void dispose() {
    _profilesCubit.close();
    _advancedDrawerController.dispose();
    super.dispose();
  }

  Future<void> _checkAlarmPermissions() async {
    final canSchedule = await NotificationService.instance
        .canScheduleExactAlarms();
    if (!canSchedule && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'برجاء تفعيل إذن "التنبيهات والمواعيد" (Alarms & Reminders) لكي تعمل تنبيهات الدواء.',
          ),
          action: SnackBarAction(
            label: 'تفعيل',
            onPressed: () {
              NotificationService.instance.openExactAlarmSettings();
            },
          ),
          duration: const Duration(seconds: 10),
        ),
      );
    }
  }

  @override
  void didUpdateWidget(covariant MainNavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTabIndex != widget.initialTabIndex) {
      _selectedIndex = widget.initialTabIndex.clamp(0, 3);
    }
    // Only refresh if the profile extra actually changed (e.g. returning from adding a profile via GoRouter.go)
    if (oldWidget.profile != widget.profile) {
      _profilesCubit.getProfiles();
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
        BlocProvider.value(
          value: _profilesCubit,
        ),
        BlocProvider(create: (context) => getIt<AuthCubit>()),
      ],
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          if (_advancedDrawerController.value.visible) {
            _advancedDrawerController.hideDrawer();
            return;
          }
          if (_selectedIndex != 0) {
            setState(() => _selectedIndex = 0);
            return;
          }
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) {
              final colors = context.colors;
              return CustomActionDialog(
                title: 'common.exit_app_title'.tr(),
                message: 'common.exit_app_content'.tr(),
                icon: Icons.exit_to_app_rounded,
                primaryColor: colors.primary,
                confirmLabel: 'common.exit_app_confirm'.tr(),
                cancelLabel: 'common.exit_app_cancel'.tr(),
                onConfirm: () => Navigator.of(context).pop(true),
                onCancel: () => Navigator.of(context).pop(false),
              );
            },
          );
          if (shouldExit == true) {
            SystemNavigator.pop();
          }
        },
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
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                HomeView(onMenuPressed: _handleMenuButtonPressed),
                const MedicinesMainView(),
                UserRecordsView(isActive: _selectedIndex == 2),
                const ProfileDetailsScreen(),
              ],
            ),
            floatingActionButton: Builder(
              builder: (innerContext) => FloatingActionButton(
                onPressed: () => fabConfig.onPressed(innerContext),
                tooltip: fabConfig.tooltip,
                child: Icon(fabConfig.icon),
              ),
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
      ),
    );
  }
}

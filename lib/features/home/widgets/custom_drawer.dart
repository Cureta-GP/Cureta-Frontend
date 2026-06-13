import 'package:cureta/core/constants/app_images.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/authentcation/veiw_model/auth_view_model.dart';
import 'package:cureta/features/authentcation/veiw_model/auth_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.controller});

  final AdvancedDrawerController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListTileTheme(
      textColor: Colors.white,
      iconColor: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 50),
          Container(
            width: 100,
            height: 100,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colors.background,
              shape: BoxShape.circle,
            ),
            child: Image.asset(AppImages.logo, fit: BoxFit.cover),
          ),
          const SizedBox(height: 40),
          _DrawerItem(
            icon: Icons.dashboard_outlined,
            label: 'drawer.dashboard'.tr(),
          ),
          _DrawerItem(
            icon: Icons.medication_outlined,
            label: 'drawer.medicines'.tr(),
            onTap: () => _openMedicines(context),
          ),
          _DrawerItem(
            icon: Icons.insert_chart_outlined_rounded,
            label: 'drawer.reports'.tr(),
            onTap: () => _openReports(context),
          ),
          _DrawerItem(
            icon: Icons.chat_bubble_outline,
            label: 'drawer.chat'.tr(),
            onTap: () => _openChat(context),
          ),
          _DrawerItem(
            icon: Icons.qr_code_outlined,
            label: 'drawer.qr_code'.tr(),
          ),
          _DrawerItem(
            icon: Icons.calendar_today_outlined,
            label: 'drawer.calendar'.tr(),
          ),
          _DrawerItem(
            icon: Icons.people_outline,
            label: 'drawer.family_profiles'.tr(),
          ),
          _DrawerItem(
            icon: Icons.settings_outlined,
            label: 'drawer.settings'.tr(),
            onTap: () => _openSettings(context),
          ),
          const Spacer(),
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthInitial) {
                Nav.clearAndGo(context, AppRoutes.login);
              } else if (state is AuthError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: SizedBox(
                width: double.infinity,
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return MaterialButton(
                      onPressed: isLoading
                          ? null
                          : () => context.read<AuthCubit>().logout(),
                      color: Colors.red.shade600,
                      disabledColor: Colors.red.shade400,
                      height: 48,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.logout, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  'drawer.logout'.tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 12.0),
            child: Text(
              'drawer.footer'.tr(),
              style: const TextStyle(fontSize: 10, color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }

  void _openChat(BuildContext context) {
    controller.hideDrawer();
    GoRouter.of(context).push(AppRoutes.chat);
  }

  void _openMedicines(BuildContext context) {
    controller.hideDrawer();
    GoRouter.of(context).push(AppRoutes.medicines);
  }

  void _openReports(BuildContext context) {
    controller.hideDrawer();
    GoRouter.of(context).push(AppRoutes.reportsHistory);
  }

  void _openSettings(BuildContext context) {
    controller.hideDrawer();
    GoRouter.of(context).push(AppRoutes.settings);
  }
}

// ── Extracted widget — replaces _buildMenuItem helper ────────────────────────

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 22),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }
}

import 'package:cureta/core/constants/app_images.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/features/authentcation/veiw_model/auth_view_model.dart';
import 'package:cureta/features/authentcation/veiw_model/auth_state.dart';

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
          _buildMenuItem(Icons.dashboard_outlined, 'Dashboard'),
          _buildMenuItem(
            Icons.medication_outlined,
            'Medicines',
            onTap: () => _openMedicines(context),
          ),
          _buildMenuItem(
            Icons.chat_bubble_outline,
            'Chat',
            onTap: () => _openChat(context),
          ),
          _buildMenuItem(Icons.qr_code_outlined, 'QR Code'),
          _buildMenuItem(Icons.calendar_today_outlined, 'Calendar'),
          _buildMenuItem(Icons.person_outline, 'Family Profiles'),
          _buildMenuItem(Icons.settings_outlined, 'Settings'),

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
                          : () {
                              context.read<AuthCubit>().logout();
                            },
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
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Logout',
                                  style: TextStyle(
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
          const Padding(
            padding: EdgeInsets.only(bottom: 20.0, top: 12.0),
            child: Text(
              'Terms of Service | Privacy Policy',
              style: TextStyle(fontSize: 10, color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }

  void _openChat(BuildContext context) {
    controller.hideDrawer();
    Nav.to(context, AppRoutes.chat);
  }

  void _openMedicines(BuildContext context) {
    controller.hideDrawer();
    Nav.to(context, AppRoutes.medicines);
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }
}

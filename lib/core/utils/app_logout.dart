import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:go_router/go_router.dart';

import 'package:cureta/core/Services/dio_helper.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/Services/notification_service.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/features/medicines/data/services/medicine_local_service.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';

class AppLogout {
  /// Clears all local user data, resets network headers, wipes local databases,
  /// clears memory caches, and navigates back to the Login screen.
  static Future<void> clearAllUserData(BuildContext context) async {
    try {
      // 1. Storage: Clear SharedPreferences
      // Removes 'token', 'profileId', and any other user-specific cached data.
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 2. Network: Remove Authorization Header
      DioHelper.clearAuthToken();

      // 3. Alarms: Cancel ALL scheduled OS-level medicine alarms and clear the
      // native alarm registry. Without this, the previous user's reminders keep
      // firing after logout and can even be re-armed after a reboot — wiping the
      // SQLite DB alone does NOT remove the scheduled AlarmManager alarms.
      try {
        await NotificationService.instance.stopAlarm();
        await NotificationService.instance.cancelAllAlarms();
      } catch (e) {
        debugPrint('Error cancelling scheduled alarms: $e');
      }

      // 4. Local Database: Wipe SQLite Databases safely
      try {
        await getIt<MedicineLocalService>().clearAllData();
      } catch (e) {
        debugPrint('Error wiping local databases: $e');
      }

      // 5. State Management: Clear In-Memory Caches in Repositories
      // The safest way to clear all Singletons (Repositories & Services) is to completely reset GetIt
      // and re-register them to ensure absolutely no ghosts remain in any repository.
      await getIt.reset();
      await setup();
      await getIt<MedicineLocalService>().init();

      // Note on Cubits: Since the app uses GetIt 'registerFactory' for Cubits,
      // and they are provided via BlocProvider at the route/page level,
      // doing a clean navigation push below will unmount the current widget tree,
      // which automatically disposes and resets all active Cubits.

    } catch (e) {
      debugPrint('Error during logout process: $e');
    } finally {
      // 5. Navigation: Ensure a clean navigation push to the Login screen
      if (context.mounted) {
        // context.go replaces the current navigation stack, dropping old contexts
        context.go(AppRoutes.login);
      }
    }
  }
}

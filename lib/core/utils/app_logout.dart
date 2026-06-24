import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:go_router/go_router.dart';

import 'package:cureta/core/Services/dio_helper.dart';
import 'package:cureta/core/Services/GetItServices.dart';
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

      // 3. Local Database: Wipe SQLite Databases
      try {
        final dbPath = await getDatabasesPath();

        // Close the current MedicineLocalService connection to release locks
        await getIt<MedicineLocalService>().close();

        // Delete the specific medicine database file
        final medicinesDbPath = join(dbPath, 'cureta_medicines.db');
        await deleteDatabase(medicinesDbPath);

        // Re-initialize MedicineLocalService so it creates a fresh empty database for the next user
        await getIt<MedicineLocalService>().init();
      } catch (e) {
        debugPrint('Error wiping local databases: $e');
      }

      // 4. State Management: Clear In-Memory Caches in Repositories
      // E.g., clear the in-memory cached profiles in ProfileRepository.
      getIt<ProfileRepository>().clearCache();

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

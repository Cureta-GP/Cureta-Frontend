import 'package:cureta/features/settings/data/model/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys used for persistence.
abstract final class _Keys {
  static const themeMode = 'settings.themeMode';
  static const languageCode = 'settings.languageCode';
}

/// A [ValueNotifier] that owns [AppSettings] and persists changes to
/// [SharedPreferences].
///
/// Register once in your GetIt setup:
/// ```dart
/// getIt.registerSingletonAsync<AppSettingsNotifier>(
///   () => AppSettingsNotifier.load(),
/// );
/// ```
class AppSettingsNotifier extends ValueNotifier<AppSettings> {
  AppSettingsNotifier._(super.value, this._prefs);

  final SharedPreferences _prefs;

  /// Loads persisted settings (or falls back to defaults) and returns a
  /// ready-to-use notifier.
  static Future<AppSettingsNotifier> load() async {
    final prefs = await SharedPreferences.getInstance();

    final themeModeIndex = prefs.getInt(_Keys.themeMode);
    final themeMode = themeModeIndex != null
        ? ThemeMode.values[themeModeIndex]
        : ThemeMode.system;

    final languageCode = prefs.getString(_Keys.languageCode);
    final locale = languageCode != null
        ? Locale(languageCode)
        : const Locale('en');

    return AppSettingsNotifier._(
      AppSettings(themeMode: themeMode, locale: locale),
      prefs,
    );
  }

  // ── Public mutators ──────────────────────────────────────────────────────

  Future<void> setThemeMode(ThemeMode mode) async {
    if (value.themeMode == mode) return;
    value = value.copyWith(themeMode: mode);
    await _prefs.setInt(_Keys.themeMode, mode.index);
  }

  Future<void> setLocale(Locale locale) async {
    if (value.locale == locale) return;
    value = value.copyWith(locale: locale);
    await _prefs.setString(_Keys.languageCode, locale.languageCode);
  }
}

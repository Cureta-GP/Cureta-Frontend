import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/settings/data/app_settings_notifier.dart';
import 'package:cureta/features/settings/data/model/app_settings.dart';
import 'package:cureta/features/settings/view/widgets/language_segment_row.dart';
import 'package:cureta/features/settings/view/widgets/navigation_row.dart';
import 'package:cureta/features/settings/view/widgets/section_header.dart';
import 'package:cureta/features/settings/view/widgets/settings_card.dart';
import 'package:cureta/features/settings/view/widgets/switch_row.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = getIt<AppSettingsNotifier>();

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          'settings.title'.tr(),
          style: context.typography.title.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
        backgroundColor: context.colors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
      ),
      body: ValueListenableBuilder<AppSettings>(
        valueListenable: notifier,
        builder: (context, settings, _) {
          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing.lg,
              vertical: context.spacing.md,
            ),
            children: [
              // ── Preferences ──────────────────────────────────────────────
              SectionHeader(label: 'settings.section.preferences'.tr()),
              SizedBox(height: context.spacing.xs),
              SettingsCard(
                children: [
                  SwitchRow(
                    icon: Icons.dark_mode_outlined,
                    label: 'settings.theme.dark'.tr(),
                    value: settings.themeMode == ThemeMode.dark,
                    onChanged: (isDark) => notifier.setThemeMode(
                      isDark ? ThemeMode.dark : ThemeMode.light,
                    ),
                  ),
                  const SettingsDivider(),
                  LanguageSegmentRow(
                    current: settings.locale,
                    onChanged: (locale) async {
                      await notifier.setLocale(locale);
                      if (context.mounted) context.setLocale(locale);
                    },
                  ),
                ],
              ),

              SizedBox(height: context.spacing.xl),

              // ── Account ───────────────────────────────────────────────────
              SectionHeader(label: 'settings.section.account'.tr()),
              SizedBox(height: context.spacing.xs),
              SettingsCard(
                children: [
                  NavigationRow(
                    icon: Icons.lock_outline,
                    label: 'settings.change_password'.tr(),
                    onTap: () {
                      // TODO: navigate to change password
                    },
                  ),
                  const SettingsDivider(),
                  NavigationRow(
                    icon: Icons.notifications_none_outlined,
                    label: 'settings.notification_settings'.tr(),
                    onTap: () {
                      // TODO: navigate to notification settings
                    },
                  ),
                ],
              ),

              SizedBox(height: context.spacing.xl),

              // ── Legal ─────────────────────────────────────────────────────
              SectionHeader(label: 'settings.section.legal'.tr()),
              SizedBox(height: context.spacing.xs),
              SettingsCard(
                children: [
                  NavigationRow(
                    icon: Icons.shield_outlined,
                    label: 'settings.privacy_policy'.tr(),
                    onTap: () {
                      // TODO: open privacy policy
                    },
                  ),
                  const SettingsDivider(),
                  NavigationRow(
                    icon: Icons.description_outlined,
                    label: 'settings.terms_of_service'.tr(),
                    onTap: () {
                      // TODO: open terms of service
                    },
                  ),
                ],
              ),

              SizedBox(height: context.spacing.xxl),

              // ── App version ───────────────────────────────────────────────
              Center(
                child: Text(
                  'settings.app_version'.tr(args: ['2.1.0 (Build 461)']),
                  style: context.typography.label.copyWith(
                    color: context.colors.textHint,
                  ),
                ),
              ),
              SizedBox(height: context.spacing.lg),
            ],
          );
        },
      ),
    );
  }
}

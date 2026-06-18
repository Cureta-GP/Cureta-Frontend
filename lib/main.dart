import 'package:cureta/core/Services/dio_helper.dart';
import 'package:cureta/core/config/routing/router_generation.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/Services/tz_helper.dart';
import 'package:cureta/core/theme/app_theme_factory.dart';
import 'package:cureta/core/theme/breakpoints.dart';
import 'package:cureta/features/medicines/data/services/medicine_local_service.dart';
import 'package:cureta/core/Services/notification_service.dart';
import 'package:cureta/features/settings/data/app_settings_notifier.dart';
import 'package:cureta/features/settings/data/model/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initializeTimezone();
  await setup();
  await getIt<MedicineLocalService>().init();
  NotificationService.instance.initCallHandler();
  await DioHelper.init();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const double _minTextScaleFactor = 0.8;
  static const double _maxTextScaleFactor = 1.5;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppSettings>(
      valueListenable: getIt<AppSettingsNotifier>(),
      builder: (context, settings, _) {
        // sync EasyLocalization when user changes language
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.locale != settings.locale) {
            context.setLocale(settings.locale);
          }
        });

        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final deviceType = _deviceTypeFromWidth(screenWidth);
            final lightTheme = AppThemeFactory.create(
              brightness: Brightness.light,
              device: deviceType,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            );
            final darkTheme = AppThemeFactory.create(
              brightness: Brightness.dark,
              device: deviceType,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            );
            return MediaQuery.withClampedTextScaling(
              minScaleFactor: _minTextScaleFactor,
              maxScaleFactor: _maxTextScaleFactor,
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                builder: (context, child) {
                  return GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    behavior: HitTestBehavior.translucent,
                    child: child!,
                  );
                },
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: settings.themeMode,
                routerConfig: RoutesGeneration.router,
                themeAnimationDuration: const Duration(milliseconds: 300),
                themeAnimationCurve: Curves.easeInOut,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
              ),
            );
          },
        );
      },
    );
  }

  DeviceType _deviceTypeFromWidth(double width) {
    if (width >= Breakpoints.desktop) return DeviceType.desktop;
    if (width >= Breakpoints.largeTablet) return DeviceType.largeTablet;
    if (width >= Breakpoints.tablet) return DeviceType.tablet;
    return DeviceType.mobile;
  }
}

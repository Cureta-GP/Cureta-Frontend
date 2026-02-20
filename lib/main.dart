import 'package:cureta/core/config/routing/router_generation.dart';
import 'package:cureta/core/theme/app_theme_factory.dart';
import 'package:cureta/core/theme/breakpoints.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

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

  @override
  Widget build(BuildContext context) {
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

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: RoutesGeneration.router,
          themeAnimationDuration: const Duration(milliseconds: 300),
          themeAnimationCurve: Curves.easeInOut,
          // Localization configuration
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
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

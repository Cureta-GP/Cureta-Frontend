import 'package:flutter/material.dart';

@immutable
class Breakpoints {
  const Breakpoints._();

  static const double mobile = 300;
  static const double tablet = 600;
  static const double largeTablet = 900;
  static const double desktop = 1200;

  static DeviceType of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= desktop) return DeviceType.desktop;
    if (width >= largeTablet) return DeviceType.largeTablet;
    if (width >= tablet) return DeviceType.tablet;
    return DeviceType.mobile;
  }
}

enum DeviceType { mobile, tablet, largeTablet, desktop }

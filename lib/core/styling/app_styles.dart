
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  // Text Styles
  static final TextStyle headingLarge = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle headingMedium = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle bodySmall = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
  );

  // Padding        
  static final EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: 16.w,
    vertical: 12.h,
  );
  
  static final EdgeInsets cardPadding = EdgeInsets.all(12.w);

  // Margin
  static final EdgeInsets elementMargin = EdgeInsets.only(bottom: 10.h);

  // Border Radius
  static final BorderRadius cardBorderRadius = BorderRadius.circular(14.r);

 

  
}
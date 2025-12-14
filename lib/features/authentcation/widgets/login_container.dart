import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginContainer extends StatelessWidget {
  final Widget child;

  const LoginContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390.w,
      height: 844.h,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.r),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 50.r,
            offset: Offset(0, 25),
            spreadRadius: -12,
          ),
        ],
      ),
      child: Container(
        constraints: BoxConstraints(minHeight: 844.h),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.50, 0.00),
            end: Alignment(0.50, 1.00),
            colors: [Colors.white, Colors.white],
          ),
        ),
        child: child,
      ),
    );
  }
}

import 'package:cureta/core/styling/app_colors.dart';
import 'package:cureta/features/authentcation/widgets/signup_form.dart';
import 'package:cureta/features/authentcation/widgets/signup_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(color: AppColors.background),
          child: Center(
            child: Container(
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
              child: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(minHeight: 844.h),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.50, 0.00),
                      end: Alignment(0.50, 1.00),
                      colors: [Colors.white, Colors.white],
                    ),
                  ),
                  child: Column(
                    children: [
                      SignupHeader(),
                      SizedBox(height: 24.h),
                      SignupForm(),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/styling/app_colors.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:cureta/features/authentcation/widgets/arrow_back.dart';
import 'package:cureta/features/authentcation/widgets/header.dart';
import 'package:cureta/features/authentcation/widgets/otp_box.dart';
import 'package:cureta/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String get otp => _controllers.map((e) => e.text).join();

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _verifyCode() {
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the full code")),
      );
      return;
    }

    // TODO: Call verify API here
    debugPrint("OTP Code: $otp");
  }

  @override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ArrowBack(),
            const Header(
              title: "Verify Your Email",
              subtitle: "We've sent a 6-digit verification code to",
            ),
            SizedBox(
              width: 342.w,
              child: Text(
                'elbannabosina@gmail.com',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 32.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return OtpBox(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  nextFocus: index < 5 ? _focusNodes[index + 1] : null,
                  previousFocus: index > 0 ? _focusNodes[index - 1] : null,
                );
              }),
            ),

            SizedBox(height: 40.h),

            CustomButton(
              text: 'Verify & Continue',
              onPressed: () async {
                if (otp.length < 6) return;
                await Nav.push(context, AppRoutes.resetPassword);
              },
            ),
          ],
        ),
      ),
    ),
  );
}
}
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/constants/app_icons.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:cureta/features/authentcation/widgets/arrow_back.dart';
import 'package:cureta/features/authentcation/widgets/header.dart';
import 'package:cureta/features/authentcation/widgets/link.dart';
import 'package:cureta/shared/widgets/custom_button.dart';
import 'package:cureta/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordView extends StatelessWidget {
  final _emailController = TextEditingController();
  ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

          children: [
             ArrowBack(),
            Header(
              title: "Forgot Password?",
              subtitle:
                  "Don't worry! Enter your email address and we'll send you a code to reset your password.",
            ),
            CustomTextField(
              label: 'Email',
              hint: 'Enter your email',
              prefixIcon: const Icon(Icons.email),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Send Verification Code',
              prefixIcon: AppIcons.send,
              onPressed: () {
                Nav.push(context, AppRoutes.verifyEmail);
                // Handle send reset code action
              },
            ),
            SizedBox(height: 29.h),
            Link(
              text: "Remember your password?",
              actionText: "  Back to Login",
              onTap: () => Nav.back(context),
            ),
          ],
        ),
      ),
    );
  }
}

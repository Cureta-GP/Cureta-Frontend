import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/constants/app_icons.dart';
import 'package:cureta/core/localization/app_localizations.dart';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               ArrowBack(),
              Header(
                title: AppLocalizations.forgotPasswordTitle,
                subtitle: AppLocalizations.forgotPasswordSubtitle,
              ),
              CustomTextField(
                label: AppLocalizations.forgotPasswordEmailLabel,
                hint: AppLocalizations.forgotPasswordEmailHint,
                prefixIcon: const Icon(Icons.email),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: AppLocalizations.sendButton,
                prefixIcon: AppIcons.send,
                onPressed: () {
                  Nav.push(context, AppRoutes.verifyEmail);
                  // Handle send reset code action
                },
              ),
              SizedBox(height: 29.h),
              Link(
                text: AppLocalizations.rememberPassword,
                actionText: AppLocalizations.backToLogin,
                onTap: () => Nav.back(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

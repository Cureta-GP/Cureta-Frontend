import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:cureta/core/utils/validators.dart';
import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';

import 'link.dart';

class LoginFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final Function(String) onEmailChanged;
  final VoidCallback? onSubmit;
  final bool isLoading;

  const LoginFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.onEmailChanged,
    this.onSubmit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: AppLocalizations.emailLabel,
          hint: AppLocalizations.emailHint,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => Validators.email(value),
          prefixIcon: const Icon(Icons.email),
          onChanged: onEmailChanged,
        ),
        SizedBox(height: spacing.xl),
        CustomTextField(
          label: AppLocalizations.passwordLabel,
          hint: AppLocalizations.passwordHint,
          controller: passwordController,
          isPassword: true,
          validator: (value) => Validators.password(value),
          prefixIcon: const Icon(Icons.lock),
          focusNode: passwordFocusNode,
        ),
        SizedBox(height: spacing.xxl),
        GestureDetector(
          onTap: () => Nav.push(context, AppRoutes.forgetPassword),
          child: Text(
            AppLocalizations.forgotPassword,
            style: typography.body.copyWith(
              color: colors.primary,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        SizedBox(height: spacing.xxl),
        CustomButton(
          text: AppLocalizations.loginButton,
          onPressed: onSubmit ?? () {},
          isLoading: isLoading,
        ),
        SizedBox(height: spacing.lg),

        Link(
          text: AppLocalizations.noAccount,
          actionText: AppLocalizations.signupLink,
          onTap: () => Nav.push(context, AppRoutes.signup),
        ),
      ],
    );
  }
}

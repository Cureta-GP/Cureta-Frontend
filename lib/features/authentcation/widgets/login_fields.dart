import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/styling/app_colors.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:cureta/core/utils/validators.dart';
import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import 'google_button.dart';
import 'link.dart';

class LoginFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final Function(String) onEmailChanged;
  final VoidCallback onSubmit;

  const LoginFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.onEmailChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Email',
          hint: 'Enter your email',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => Validators.email(value),
          prefixIcon: const Icon(Icons.email),
          onChanged: onEmailChanged,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'Password',
          hint: 'Enter your password',
          controller: passwordController,
          isPassword: true,
          validator: (value) => Validators.password(value),
          prefixIcon: const Icon(Icons.lock),
          focusNode: passwordFocusNode,
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => Nav.push(context, AppRoutes.forgetPassword),
          child: Text(
            "Forgot Password?",
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w700,
              height: 1.50,
            ),
          ),
        ),

        const SizedBox(height: 24),
        CustomButton(text: 'Login', onPressed: onSubmit),
        const SizedBox(height: 16),
        const GoogleButton(),
        const SizedBox(height: 24),
        Link(
          text: "Don't have an account? ",
          actionText: "Sign Up",
          onTap: () => Nav.push(context, AppRoutes.signup),
        ),
      ],
    );
  }
}

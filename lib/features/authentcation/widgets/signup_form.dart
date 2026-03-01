// widgets/signup_form.dart
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:cureta/core/utils/validators.dart';
import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import 'google_button.dart';
import 'link.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});
  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      Nav.push(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.xl),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          children: [
            CustomTextField(
              label: AppLocalizations.nameLabel,
              hint: AppLocalizations.nameHint,
              controller: _nameController,
              validator: (value) => Validators.fullName(value),
              prefixIcon: const Icon(Icons.person),
            ),
            SizedBox(height: spacing.xl),
            CustomTextField(
              label: AppLocalizations.signupEmailLabel,
              hint: AppLocalizations.signupEmailHint,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Validators.email(value),
              prefixIcon: const Icon(Icons.email),
            ),
            SizedBox(height: spacing.xl),
            CustomTextField(
              label: AppLocalizations.signupPasswordLabel,
              hint: AppLocalizations.signupPasswordHint,
              controller: _passwordController,
              isPassword: true,
              validator: (value) => Validators.password(value),
              prefixIcon: const Icon(Icons.lock),
            ),
            SizedBox(height: spacing.xl),
            CustomTextField(
              label: AppLocalizations.phoneLabel,
              hint: AppLocalizations.phoneHint,
              controller: _addressController,
              prefixIcon: const Icon(Icons.phone),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: spacing.xxl),
            CustomButton(
              text: AppLocalizations.signupButton,
              onPressed: _handleSubmit,
            ),
            SizedBox(height: spacing.lg),
            const GoogleButton(),
            SizedBox(height: spacing.xxl),
            Link(
              text: AppLocalizations.haveAccount,
              actionText: AppLocalizations.loginLink,
              onTap: () => Nav.push(context, AppRoutes.login),
            ),
          ],
        ),
      ),
    );
  }
}

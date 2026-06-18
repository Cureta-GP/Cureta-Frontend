// widgets/signup_form.dart
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:cureta/core/utils/validators.dart';
import 'package:cureta/core/error_handling/error_handler.dart';
import 'package:cureta/features/authentcation/veiw_model/auth_state.dart';
import 'package:cureta/features/authentcation/veiw_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
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
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final cubit = context.read<AuthCubit>();

    if (_formKey.currentState!.validate()) {
      cubit.signUp(
        username: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Navigate to login after successful signup
          Nav.clearAndGo(context, AppRoutes.login);
        } else if (state is AuthError) {
          // Show error
          if (state.exception != null) {
            ErrorHandler.show(context, state.exception!);
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        }
      },
      child: Padding(
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
                controller: _phoneController,
                prefixIcon: const Icon(Icons.phone),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: spacing.xxl),
              CustomButton(
                text: AppLocalizations.signupButton,
                onPressed: _handleSubmit,
                isLoading: context.select<AuthCubit, bool>(
                  (cubit) => cubit.state is AuthLoading,
                ),
              ),
              SizedBox(height: spacing.lg),

              Link(
                text: AppLocalizations.haveAccount,
                actionText: AppLocalizations.loginLink,
                onTap: () => Nav.push(context, AppRoutes.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

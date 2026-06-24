import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:cureta/core/utils/validators.dart';
import 'package:cureta/features/authentcation/widgets/arrow_back.dart';
import 'package:cureta/features/authentcation/widgets/header.dart';
import 'package:cureta/shared/widgets/custom_button.dart';
import 'package:cureta/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../veiw_model/forgot_password_view_model.dart';
import '../veiw_model/forgot_password_state.dart';
import 'package:cureta/core/config/routing/app_routes.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ForgotPasswordViewModel>().resetPassword(
        otp: '',
        newPassword: _newPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.xl),
          child: SingleChildScrollView(
            child: BlocListener<ForgotPasswordViewModel, ForgotPasswordState>(
              listener: (context, state) {
                if (state is ResetPasswordSuccess) {
                  Nav.replace(context, AppRoutes.login);
                } else if (state is ForgotPasswordError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ArrowBack(),
                    Header(
                      title: AppLocalizations.resetPasswordTitle,
                      subtitle: AppLocalizations.resetPasswordSubtitle,
                    ),
                    CustomTextField(
                      label: AppLocalizations.newPasswordLabel,
                      hint: AppLocalizations.newPasswordHint,
                      prefixIcon: const Icon(Icons.lock),
                      controller: _newPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      isPassword: true,
                      validator: (value) => Validators.password(value),
                    ),
                    SizedBox(height: spacing.xxl),
                    CustomTextField(
                      label: AppLocalizations.confirmPasswordLabel,
                      hint: AppLocalizations.confirmPasswordHint,
                      prefixIcon: const Icon(Icons.lock),
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      isPassword: true,
                      validator: (value) => Validators.confirmPassword(
                        value,
                        _newPasswordController.text,
                      ),
                    ),
                    SizedBox(height: spacing.xl),
                    BlocBuilder<ForgotPasswordViewModel, ForgotPasswordState>(
                      builder: (context, state) {
                        final isLoading = state is ForgotPasswordLoading;
                        return CustomButton(
                          text: AppLocalizations.resetPasswordButton,
                          onPressed: isLoading
                              ? null
                              : () => _handleSubmit(context),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

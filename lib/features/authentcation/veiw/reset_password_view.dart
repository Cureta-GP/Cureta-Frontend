import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:cureta/features/authentcation/widgets/arrow_back.dart';
import 'package:cureta/features/authentcation/widgets/header.dart';
import 'package:cureta/shared/widgets/custom_button.dart';
import 'package:cureta/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../veiw_model/forgot_password_view_model.dart';
import '../veiw_model/forgot_password_state.dart';
import 'package:cureta/core/config/routing/app_routes.dart';

class ResetPasswordView extends StatelessWidget {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: SingleChildScrollView(
          child: BlocListener<ForgotPasswordViewModel, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ResetPasswordSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password reset successfully')),
                );
                Nav.replace(context, AppRoutes.login);
              } else if (state is ForgotPasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
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
                ),
                SizedBox(height: spacing.xxl),
                CustomTextField(
                  label: AppLocalizations.confirmPasswordLabel,
                  hint: AppLocalizations.confirmPasswordHint,
                  prefixIcon: const Icon(Icons.lock),
                  controller: _confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  isPassword: true,
                ),
                SizedBox(height: spacing.xl),
                BlocBuilder<ForgotPasswordViewModel, ForgotPasswordState>(
                  builder: (context, state) {
                    final isLoading = state is ForgotPasswordLoading;
                    return CustomButton(
                      text: AppLocalizations.resetPasswordButton,
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_newPasswordController.text.isEmpty ||
                                  _confirmPasswordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Please fill all fields'),
                                  ),
                                );
                                return;
                              }
                              if (_newPasswordController.text !=
                                  _confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Passwords do not match'),
                                  ),
                                );
                                return;
                              }
                              context
                                  .read<ForgotPasswordViewModel>()
                                  .resetPassword(
                                    otp: '',
                                    newPassword:
                                        _newPasswordController.text,
                                  );
                            },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

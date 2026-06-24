import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/constants/app_icons.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:cureta/core/utils/validators.dart';
import 'package:cureta/features/authentcation/widgets/arrow_back.dart';
import 'package:cureta/features/authentcation/widgets/header.dart';
import 'package:cureta/features/authentcation/widgets/link.dart';
import 'package:cureta/shared/widgets/custom_button.dart';
import 'package:cureta/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../veiw_model/forgot_password_view_model.dart';
import '../veiw_model/forgot_password_state.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ForgotPasswordViewModel>().sendOTP(
        _emailController.text.trim(),
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
                if (state is ForgotPasswordEmailSentSuccess) {
                  Nav.push(
                    context,
                    AppRoutes.verifyEmail,
                    extra: _emailController.text,
                  );
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
                      title: AppLocalizations.forgotPasswordTitle,
                      subtitle: AppLocalizations.forgotPasswordSubtitle,
                    ),
                    CustomTextField(
                      label: AppLocalizations.forgotPasswordEmailLabel,
                      hint: AppLocalizations.forgotPasswordEmailHint,
                      prefixIcon: const Icon(Icons.email),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => Validators.email(value),
                    ),
                    SizedBox(height: spacing.xl),
                    BlocBuilder<ForgotPasswordViewModel, ForgotPasswordState>(
                      builder: (context, state) {
                        final isLoading = state is ForgotPasswordLoading;
                        return CustomButton(
                          text: AppLocalizations.sendButton,
                          prefixIcon: AppIcons.send,
                          onPressed: isLoading
                              ? null
                              : () => _handleSubmit(context),
                        );
                      },
                    ),
                    SizedBox(height: spacing.xxl),
                    Link(
                      text: AppLocalizations.rememberPassword,
                      actionText: AppLocalizations.backToLogin,
                      onTap: () => Nav.back(context),
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

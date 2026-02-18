import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/authentcation/widgets/arrow_back.dart';
import 'package:cureta/features/authentcation/widgets/header.dart';
import 'package:cureta/shared/widgets/custom_button.dart';
import 'package:cureta/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

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
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: spacing.xxl),
              CustomTextField(
                label: AppLocalizations.confirmPasswordLabel,
                hint: AppLocalizations.confirmPasswordHint,
                prefixIcon: const Icon(Icons.lock),
                controller: _confirmPasswordController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: spacing.xl),
              CustomButton(
                text: AppLocalizations.resetPasswordButton,

                onPressed: () {
                  // Handle send reset code action
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

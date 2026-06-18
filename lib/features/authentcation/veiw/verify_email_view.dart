import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:cureta/features/authentcation/widgets/arrow_back.dart';
import 'package:cureta/features/authentcation/widgets/header.dart';
import 'package:cureta/features/authentcation/widgets/otp_box.dart';
import 'package:cureta/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../veiw_model/forgot_password_view_model.dart';
import '../veiw_model/forgot_password_state.dart';

class VerifyEmailView extends StatefulWidget {
  final String email;

  const VerifyEmailView({super.key, required this.email});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String get otp => _controllers.map((e) => e.text).join();

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _verifyCode() {
    if (otp.length < 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppLocalizations.otpError)));
      return;
    }

    // Call verify OTP via repository
    context.read<ForgotPasswordViewModel>().verifyOTP(otp);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;
    final typography = context.typography;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.xl),
          child: SingleChildScrollView(
            child: BlocListener<ForgotPasswordViewModel, ForgotPasswordState>(
              listener: (context, state) {
                if (state is ForgotPasswordEmailSentSuccess) {
                  // Changed to listen for successful OTP entry
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('OTP verified successfully')),
                  );
                  Nav.push(context, AppRoutes.resetPassword);
                } else if (state is ForgotPasswordError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArrowBack(),
                  Header(
                    title: AppLocalizations.verifyEmailTitle,
                    subtitle: AppLocalizations.verifyEmailSubtitle,
                  ),

                  Text(
                    widget.email,
                    textAlign: TextAlign.center,
                    style: typography.body.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: spacing.xxl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return OtpBox(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        nextFocus: index < 5 ? _focusNodes[index + 1] : null,
                        previousFocus: index > 0
                            ? _focusNodes[index - 1]
                            : null,
                      );
                    }),
                  ),
                  SizedBox(height: spacing.xxl + spacing.sm),
                  BlocBuilder<ForgotPasswordViewModel, ForgotPasswordState>(
                    builder: (context, state) {
                      final isLoading = state is ForgotPasswordLoading;
                      return CustomButton(
                        text: AppLocalizations.verifyButton,
                        onPressed: isLoading
                            ? null
                            : () {
                                if (otp.length < 6) return;
                                _verifyCode();
                              },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

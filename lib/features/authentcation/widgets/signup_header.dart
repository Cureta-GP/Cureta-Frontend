// widgets/signup_header.dart
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final typography = context.typography;
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: spacing.xxl * 2, bottom: spacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.signupTitle,
            textAlign: TextAlign.center,
            style: typography.hero.copyWith(
              //color: colors.primaryDark,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: spacing.md),
          Text(
            AppLocalizations.signupSubtitle,
            textAlign: TextAlign.center,
            style: typography.body.copyWith(
              color: colors.textSecondary,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

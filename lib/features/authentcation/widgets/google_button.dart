// widgets/google_button.dart
import 'package:cureta/core/constants/app_images.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    return SizedBox(
      width: double.infinity,
      height: spacing.xxl + spacing.xl,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 2, color: colors.divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.md),
          ),
          backgroundColor: colors.background,
          padding: EdgeInsets.symmetric(horizontal: spacing.lg),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.google,
              width: spacing.xxl,
              height: spacing.xxl,
            ),
            SizedBox(width: spacing.md),
            Text(
              AppLocalizations.continueWithGoogle,
              style: typography.body.copyWith(
                color: colors.textPrimary,
                fontFamily: 'Arimo',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

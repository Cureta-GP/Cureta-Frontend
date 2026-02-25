import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    final styles = context.typography;
    final spacing = context.spacing;
    final colors = context.colors;

    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.md,
        ),
        child: TextButton(
          onPressed: () {
            GoRouter.of(context).go(AppRoutes.login);
          },
          child: Text(
            AppLocalizations.skip,
            style: styles.label.copyWith(color: colors.primary),
          ),
        ),
      ),
    );
  }
}

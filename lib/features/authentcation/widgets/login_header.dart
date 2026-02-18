import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginHeader extends StatelessWidget {
  final Artboard? riveArtboard;

  const LoginHeader({super.key, required this.riveArtboard});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final typography = context.typography;
    final colors = context.colors;
    final headerHeight = (MediaQuery.sizeOf(context).height * 0.3).clamp(
      220.0,
      320.0,
    );

    return SizedBox(
      height: headerHeight,
      width: double.infinity,
      child: riveArtboard == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: spacing.xxl + spacing.xl,
                    color: colors.primary.withValues(alpha: 0.75),
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    AppLocalizations.loadingAnimation,
                    style: typography.label.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : Rive(artboard: riveArtboard!, fit: BoxFit.cover),
    );
  }
}

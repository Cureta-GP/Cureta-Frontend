import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/constants/app_images.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:cureta/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class QrView extends StatelessWidget {
  const QrView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        title: Text(
          AppLocalizations.qrTitle,
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            children: [
              Image.asset(AppImages.secureQr, width: 200, height: 300),

              Text(
                textAlign: TextAlign.center,
                AppLocalizations.qrHeading,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: spacing.sm),
              Text(
                textAlign: TextAlign.center,
                AppLocalizations.qrDescription,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
              ),
              SizedBox(height: spacing.xl),

              CustomButton(
                text: AppLocalizations.qrButton,
                onPressed: () async {
                  final profileId = await getIt<ProfileRepository>()
                      .getResolvedSelectedProfileId();
                  if (!context.mounted) return;

                  Nav.pushNamed(
                    context,
                    AppRoutes.qrFilterData,
                    extra: profileId ?? '',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

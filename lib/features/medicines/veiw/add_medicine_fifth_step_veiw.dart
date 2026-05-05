import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/shared/widgets/add_record_next_button.dart';

class AddMedicineFifthStepVeiw extends StatelessWidget {
  const AddMedicineFifthStepVeiw({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 64,
                  color: colors.primary,
                ),
              ),
              SizedBox(height: spacing.xxl),
              Text(
                AppLocalizations.medicinesSuccessTitle,
                style: typography.title.copyWith(color: colors.textPrimary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.md),
              Text(
                AppLocalizations.medicinesSuccessSubtitle,
                style: typography.body.copyWith(color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AddRecordNextButton(
                  label: AppLocalizations.medicinesGoToMyMedicines,
                  onPressed: () {
                    context.read<AddMedicineCubit>().resetForm();
                    // Navigate to main screen with medicines tab selected.
                    // Using go() clears the entire stack so back goes to home.
                    context.go(
                      '${AppRoutes.mainNavigation}?tab=1',
                    );
                  },
                ),
              ),
              SizedBox(height: spacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

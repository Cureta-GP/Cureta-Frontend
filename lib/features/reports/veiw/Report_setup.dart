import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/features/profile/data/models/profile_model.dart';
import '../veiw_model/report_setup_cubit.dart';
import '../veiw_model/report_setup_state.dart';
import '../widgets/report_time_period_selector_widget.dart';
import '../widgets/report_language_toggle_widget.dart';
import '../widgets/report_profile_selector_widget.dart';

class ReportSetupView extends StatelessWidget {
  const ReportSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReportSetupCubit>()..init(),
      child: const _ReportSetupBody(),
    );
  }
}

class _ReportSetupBody extends StatelessWidget {
  const _ReportSetupBody();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final radius = context.radius;

    return BlocConsumer<ReportSetupCubit, ReportSetupState>(
      listenWhen: (_, curr) => curr is ReportSetupSuccess,
      listener: (context, state) {
        if (state is ReportSetupSuccess) {
          context.pop();
          context.push(AppRoutes.reportDetails, extra: state.report);
        }
      },
      builder: (context, state) {
        final cubit = context.read<ReportSetupCubit>();
        final isGenerating = state is ReportSetupGenerating;
        final profiles = _profiles(state);
        final canGenerate = !isGenerating && profiles.isNotEmpty;

        return Scaffold(
          backgroundColor: colors.background,
          appBar: AppBar(
            backgroundColor: colors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colors.textPrimary),
              onPressed: () => context.pop(),
            ),
            centerTitle: true,
            title: Text(
              'reports.generate_report'.tr(),
              style: typography.medicalRecordScreenTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(spacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: spacing.md),

                  // ── Profile selector ──────────────────────────────────────
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: spacing.xs),
                    child: Text(
                      'reports.select_profile'.tr(),
                      style: typography.medicalRecordDetailLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(height: spacing.md),
                  if (profiles.isEmpty)
                    const ReportProfileSelectorShimmer()
                  else
                    ReportProfileSelectorWidget(
                      profiles: profiles,
                      selectedProfile: _selectedProfile(state),
                      onSelected: cubit.selectProfile,
                    ),
                  SizedBox(height: spacing.xl),

                  // ── Time period ───────────────────────────────────────────
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: spacing.xs),
                    child: Text(
                      'reports.select_period'.tr(),
                      style: typography.medicalRecordDetailLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(height: spacing.md),
                  ReportTimePeriodSelectorWidget(
                    selectedPeriod: _period(state),
                    onSelected: cubit.selectTimePeriod,
                  ),
                  SizedBox(height: spacing.xl),

                  // ── Language ──────────────────────────────────────────────
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: spacing.xs),
                    child: Text(
                      'reports.select_language'.tr(),
                      style: typography.medicalRecordDetailLabel.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(height: spacing.md),
                  ReportLanguageToggleWidget(
                    selectedLanguage: _language(state),
                    onSelected: cubit.selectLanguage,
                  ),
                  SizedBox(height: spacing.xxl),

                  // ── Generate button ───────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: canGenerate ? cubit.generateReport : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.background,
                        disabledBackgroundColor: colors.primary,
                        disabledForegroundColor: colors.background,
                        padding: EdgeInsets.symmetric(vertical: spacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radius.full),
                        ),
                      ),
                      child: isGenerating
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.background,
                              ),
                            )
                          : Text(
                              'reports.generate'.tr(),
                              style: typography.medicalRecordButton.copyWith(
                                color: colors.background,
                              ),
                            ),
                    ),
                  ),

                  // ── Error message ─────────────────────────────────────────
                  if (state is ReportSetupError)
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: spacing.md),
                      child: Text(
                        state.messageKey.tr(),
                        style: typography.label.copyWith(color: colors.error),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  SizedBox(height: spacing.xl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _period(ReportSetupState s) => switch (s) {
    ReportSetupInitial s => s.timePeriod,
    ReportSetupUpdated s => s.timePeriod,
    ReportSetupGenerating s => s.timePeriod,
    ReportSetupError s => s.timePeriod,
    _ => 'last_month',
  };

  String _language(ReportSetupState s) => switch (s) {
    ReportSetupInitial s => s.language,
    ReportSetupUpdated s => s.language,
    ReportSetupGenerating s => s.language,
    ReportSetupError s => s.language,
    _ => 'en',
  };

  List<ProfileModel> _profiles(ReportSetupState s) => switch (s) {
    ReportSetupInitial s => s.profiles,
    ReportSetupUpdated s => s.profiles,
    ReportSetupGenerating s => s.profiles,
    ReportSetupError s => s.profiles,
    _ => const [],
  };

  ProfileModel? _selectedProfile(ReportSetupState s) => switch (s) {
    ReportSetupInitial s => s.selectedProfile,
    ReportSetupUpdated s => s.selectedProfile,
    ReportSetupGenerating s => s.selectedProfile,
    ReportSetupError s => s.selectedProfile,
    _ => null,
  };
}

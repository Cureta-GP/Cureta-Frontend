import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
import '../veiw_model/report_history_cubit.dart';
import '../veiw_model/report_history_state.dart';
import '../widgets/report_history_card_widget.dart';
import '../widgets/report_history_shimmer_widget.dart';
import '../widgets/report_history_empty_state_widget.dart';

class ReportHistoryView extends StatelessWidget {
  const ReportHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReportHistoryCubit>()..loadHistory(),
      child: const _ReportHistoryBody(),
    );
  }
}

class _ReportHistoryBody extends StatelessWidget {
  const _ReportHistoryBody();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'reports.my_reports'.tr(),
          style: typography.medicalRecordScreenTitle.copyWith(
            color: colors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: colors.textPrimary),
            onPressed: () => context.read<ReportHistoryCubit>().refresh(),
          ),
        ],
      ),
      body: BlocBuilder<ReportHistoryCubit, ReportHistoryState>(
        builder: (context, state) {
          return switch (state) {
            ReportHistoryInitial() => const SizedBox.shrink(),
            ReportHistoryLoading() => const ReportHistoryShimmerWidget(),
            ReportHistoryEmpty() => ReportHistoryEmptyStateWidget(
              onGenerate: () async {
                await context.push(AppRoutes.reportSetup);
                if (context.mounted) {
                  context.read<ReportHistoryCubit>().loadHistory();
                }
              },
            ),
            ReportHistoryLoaded() => RefreshIndicator(
              onRefresh: () => context.read<ReportHistoryCubit>().refresh(),
              color: colors.primary,
              child: ListView.separated(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: spacing.xl,
                  vertical: spacing.md,
                ),
                itemCount: state.reports.length,
                separatorBuilder: (_, _) => SizedBox(height: spacing.md),
                itemBuilder: (_, i) => ReportHistoryCardWidget(
                  report: state.reports[i],
                  onTap: () => context.push(
                    AppRoutes.reportDetails,
                    extra: state.reports[i],
                  ),
                ),
              ),
            ),
            ReportHistoryError() => _ErrorBody(messageKey: state.messageKey),
          };
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push(AppRoutes.reportSetup);
          if (context.mounted) {
            context.read<ReportHistoryCubit>().loadHistory();
          }
        },
        backgroundColor: colors.primary,
        foregroundColor: colors.background,
        icon: const Icon(Icons.add_chart),
        label: Text(
          'reports.new_report'.tr(),
          style: typography.medicalRecordButton,
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.messageKey});
  final String messageKey;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colors.error),
            SizedBox(height: spacing.md),
            Text(
              messageKey.tr(),
              style: context.typography.body.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.lg),
            ElevatedButton(
              onPressed: () => context.read<ReportHistoryCubit>().loadHistory(),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.radius.full),
                ),
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

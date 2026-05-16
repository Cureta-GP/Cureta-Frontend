import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/home/view_model/home_schedule_cubit.dart';
import 'package:cureta/features/home/view_model/home_schedule_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TodayStatsRow extends StatelessWidget {
  const TodayStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScheduleCubit, HomeScheduleState>(
      builder: (context, state) {
        return switch (state) {
          HomeScheduleLoading() => _StatsShimmer(),
          HomeScheduleLoaded() => _StatsLoaded(state: state),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class _StatsLoaded extends StatelessWidget {
  const _StatsLoaded({required this.state});
  final HomeScheduleLoaded state;

  @override
  Widget build(BuildContext context) {
    final total = state.entries.length;
    final taken = state.taken.length;
    final next = state.nextDose;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'home.stats.today_meds'.tr(),
            value: '$taken/$total',
            sub: total - taken == 0
                ? 'home.stats.all_done'.tr()
                : 'home.stats.remaining'.tr(args: ['${total - taken}']),
            subColor: total - taken == 0
                ? context.colors.success
                : context.colors.warning,
          ),
        ),
        SizedBox(width: context.spacing.sm),
        Expanded(
          child: _StatCard(
            label: 'home.stats.next_dose'.tr(),
            value: next != null
                ? DateFormat('hh:mm a').format(next.scheduledAt)
                : '—',
            sub: next?.name ?? 'home.stats.no_pending'.tr(),
            subColor: next != null
                ? context.colors.warning
                : context.colors.textHint,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.subColor,
  });

  final String label;
  final String value;
  final String sub;
  final Color subColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.spacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(context.radius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.typography.label.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: context.spacing.xs / 2),
          Text(value, style: context.typography.title),
          SizedBox(height: context.spacing.xs / 2),
          Text(
            sub,
            style: context.typography.label.copyWith(color: subColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _StatsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _ShimmerBox()),
        SizedBox(width: context.spacing.sm),
        Expanded(child: _ShimmerBox()),
      ],
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(context.radius.lg),
      ),
    );
  }
}

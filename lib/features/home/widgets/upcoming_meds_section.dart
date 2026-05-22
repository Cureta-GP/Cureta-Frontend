import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/home/data/models/schedule_entry.dart';
import 'package:cureta/features/home/view_model/home_schedule_cubit.dart';
import 'package:cureta/features/home/view_model/home_schedule_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpcomingMedsSection extends StatelessWidget {
  const UpcomingMedsSection({super.key, this.onSeeAll});

  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(onSeeAll: onSeeAll),
        SizedBox(height: context.spacing.xs),
        BlocBuilder<HomeScheduleCubit, HomeScheduleState>(
          builder: (context, state) {
            return switch (state) {
              HomeScheduleLoading() => const _LoadingList(),
              HomeScheduleLoaded() => _MedList(entries: state.entries),
              HomeScheduleError() => _ErrorView(message: state.message),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({this.onSeeAll});
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'home.upcoming_meds'.tr(),
          style: typography.homeSectionTitle.copyWith(
            color: colors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            'home.see_all'.tr(),
            style: context.typography.label.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _MedList extends StatelessWidget {
  const _MedList({required this.entries});
  final List<ScheduleEntry> entries;

  static const _maxVisible = 3;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return _EmptyMeds();

    return Column(
      children: entries
          .take(_maxVisible)
          .map(
            (e) => Padding(
              key: ValueKey('${e.medicineId}_${e.scheduledAt.toIso8601String()}_${e.status.raw}'),
              padding: EdgeInsets.only(bottom: context.spacing.xs),
              child: _MedCard(entry: e),
            ),
          )
          .toList(),
    );
  }
}

class _MedCard extends StatelessWidget {
  const _MedCard({required this.entry});
  final ScheduleEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isMissed = entry.status == DoseStatus.missed;
    final isTaken = entry.status == DoseStatus.taken;

    // ── icon background ───────────────────────────────────────────────────
    final iconBg = isMissed
        ? colors.warning.withValues(alpha: 0.15) // ✅ was accentOrange
        : isTaken
        ? colors.accentCyan.withValues(alpha: 0.4)
        : colors.accentCyan;

    final iconColor = isMissed
        ? colors
              .warning // ✅ was hardcoded 0xFFE65100
        : isTaken
        ? colors.textHint
        : colors.primary;

    // ── time badge ────────────────────────────────────────────────────────
    final timeBadgeBg = isMissed
        ? colors.warning.withValues(alpha: 0.15) // ✅ was accentOrange
        : isTaken
        ? colors.surface
        : colors.accentCyan;

    final timeBadgeColor = isMissed
        ? colors
              .warning // ✅ was hardcoded 0xFFE65100
        : isTaken
        ? colors.textHint
        : colors.chatAssistantLabel;

    // ── card border ───────────────────────────────────────────────────────
    final borderColor = isMissed
        ? colors.warning.withValues(alpha: 0.4) // ✅ was accentOrange.withOpacity
        : colors.divider;

    final timeLabel = isMissed
        ? 'home.missed'.tr()
        : isTaken
        ? 'home.taken'.tr()
        : DateFormat('hh:mm a').format(entry.scheduledAt);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.md,
        vertical: context.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(context.radius.lg),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(context.radius.md),
            ),
            child: Icon(Icons.medication_outlined, color: iconColor, size: 18),
          ),
          SizedBox(width: context.spacing.md),
          Expanded(
            child: Text(
              entry.name,
              style: context.typography.body.copyWith(
                color: isTaken ? colors.textHint : colors.textPrimary,
                decoration: isTaken ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing.sm,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: timeBadgeBg,
              borderRadius: BorderRadius.circular(context.radius.full),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isMissed
                      ? Icons.warning_amber_rounded
                      : isTaken
                      ? Icons.check_circle_outline
                      : Icons.access_time_rounded,
                  size: 12,
                  color: timeBadgeColor,
                ),
                const SizedBox(width: 4),
                Text(
                  timeLabel,
                  style: context.typography.label.copyWith(
                    color: timeBadgeColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyMeds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.spacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(context.radius.lg),
      ),
      child: Center(
        child: Text(
          'home.no_meds_today'.tr(),
          style: context.typography.label.copyWith(
            color: context.colors.textHint,
          ),
        ),
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (_) => Padding(
          padding: EdgeInsets.only(bottom: context.spacing.xs),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(context.radius.lg),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: context.typography.label.copyWith(color: context.colors.error),
    );
  }
}

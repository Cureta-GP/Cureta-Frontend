import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/home/data/models/schedule_entry.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ScheduleMedCard extends StatelessWidget {
  const ScheduleMedCard({
    super.key,
    required this.entry,
    required this.isUpdating,
    required this.onMarkTaken,
    required this.onMarkMissed,
    required this.onMarkPending,
  });

  final ScheduleEntry entry;
  final bool isUpdating;
  final VoidCallback onMarkTaken;
  final VoidCallback onMarkMissed;
  final VoidCallback onMarkPending;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    final isMissed = entry.status == DoseStatus.missed;
    final isTaken = entry.status == DoseStatus.taken;
    final isPending = entry.status == DoseStatus.pending;

    final iconBg = isMissed
        ? colors.warning.withValues(alpha: 0.15)
        : isTaken
        ? colors.accentCyan.withValues(alpha: 0.4)
        : colors.accentCyan;

    final iconColor = isMissed
        ? colors.warning
        : isTaken
        ? colors.textHint
        : colors.primary;

    final borderColor = isMissed
        ? colors.warning.withValues(alpha: 0.4)
        : isPending
        ? colors.primary.withValues(alpha: 0.3)
        : colors.divider;

    final timeLabel = DateFormat('hh:mm a').format(entry.scheduledAt);

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius.lg),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(radius.md),
                ),
                child: Icon(
                  Icons.medication_outlined,
                  color: iconColor,
                  size: 18,
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.name,
                      style: typography.body.copyWith(
                        color: isTaken ? colors.textHint : colors.textPrimary,
                        decoration: isTaken ? TextDecoration.lineThrough : null,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: spacing.xs / 2),
                    Text(
                      timeLabel,
                      style: typography.label.copyWith(color: colors.textHint),
                    ),
                  ],
                ),
              ),
              if (isUpdating)
                SizedBox(
                  width: spacing.lg,
                  height: spacing.lg,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.primary,
                  ),
                )
              else
                _StatusChip(status: entry.status),
            ],
          ),
          SizedBox(height: spacing.md),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'home.taken'.tr(),
                  icon: Icons.check_circle_outline,
                  isActive: isTaken,
                  activeColor: colors.primary,
                  onPressed: isUpdating ? null : onMarkTaken,
                ),
              ),
              SizedBox(width: spacing.xs),
              Expanded(
                child: _ActionButton(
                  label: 'home.pending'.tr(),
                  icon: Icons.access_time_rounded,
                  isActive: isPending,
                  activeColor: colors.chatAssistantLabel,
                  onPressed: isUpdating ? null : onMarkPending,
                ),
              ),
              SizedBox(width: spacing.xs),
              Expanded(
                child: _ActionButton(
                  label: 'home.missed'.tr(),
                  icon: Icons.warning_amber_rounded,
                  isActive: isMissed,
                  activeColor: colors.warning,
                  onPressed: isUpdating ? null : onMarkMissed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final DoseStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    final (Color bg, Color fg, String label, IconData icon) = switch (status) {
      DoseStatus.taken => (
        colors.primary.withValues(alpha: 0.12),
        colors.primary,
        'home.taken'.tr(),
        Icons.check_circle_outline,
      ),
      DoseStatus.missed => (
        colors.warning.withValues(alpha: 0.15),
        colors.warning,
        'home.missed'.tr(),
        Icons.warning_amber_rounded,
      ),
      DoseStatus.pending => (
        colors.accentCyan,
        colors.chatAssistantLabel,
        'home.pending'.tr(),
        Icons.access_time_rounded,
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(context.radius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: typography.label.copyWith(
              color: fg,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: isActive ? activeColor : colors.textSecondary,
        backgroundColor: isActive ? activeColor.withValues(alpha: 0.1) : null,
        side: BorderSide(
          color: isActive ? activeColor : colors.divider,
          width: isActive ? 1.5 : 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.md),
        ),
        padding: EdgeInsets.symmetric(
          vertical: spacing.sm,
          horizontal: spacing.xs / 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          SizedBox(height: spacing.xs / 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: typography.label.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

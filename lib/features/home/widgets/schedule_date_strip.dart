import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ScheduleDateStrip extends StatelessWidget {
  const ScheduleDateStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.daysBefore = 6,
    this.daysAfter = 13,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final int daysBefore;
  final int daysAfter;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final today = _normalize(DateTime.now());
    final dates = List.generate(
      daysBefore + daysAfter + 1,
      (index) => today.subtract(Duration(days: daysBefore - index)),
    );

    return SizedBox(
      height: spacing.xxl + spacing.xl,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: spacing.lg),
        itemCount: dates.length,
        separatorBuilder: (_, _) => SizedBox(width: spacing.sm),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _isSameDay(date, selectedDate);
          final isToday = _isSameDay(date, today);

          return _DateCell(
            date: date,
            isSelected: isSelected,
            isToday: isToday,
            onTap: () => onDateSelected(date),
          );
        },
      ),
    );
  }

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DateCell extends StatelessWidget {
  const _DateCell({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    final bgColor = isSelected
        ? colors.primary
        : isToday
        ? colors.primary.withValues(alpha: 0.1)
        : colors.surface;
    final textColor = isSelected
        ? Colors.white
        : isToday
        ? colors.primary
        : colors.textPrimary;
    final subtextColor = isSelected
        ? Colors.white.withValues(alpha: 0.85)
        : colors.textHint;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: spacing.xxl + spacing.lg,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(radius.lg),
          border: Border.all(
            color: isSelected
                ? colors.primary
                : isToday
                ? colors.primary.withValues(alpha: 0.4)
                : colors.divider,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date),
              style: typography.label.copyWith(
                color: subtextColor,
                fontSize: 11,
              ),
            ),
            SizedBox(height: spacing.xs / 2),
            Text(
              DateFormat('d').format(date),
              style: typography.body.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

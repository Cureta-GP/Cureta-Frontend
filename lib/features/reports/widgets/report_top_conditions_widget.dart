import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import '../data/models/top_condition_model.dart';

class ReportTopConditionsWidget extends StatelessWidget {
  const ReportTopConditionsWidget({super.key, required this.conditions});

  final List<TopConditionModel> conditions;

  @override
  Widget build(BuildContext context) {
    if (conditions.isEmpty) return const SizedBox.shrink();

    final items = conditions.take(5).toList();
    final maxCount = items
        .map((condition) => condition.count)
        .fold<int>(0, (previous, count) => count > previous ? count : previous);

    return Column(
      children: List.generate(items.length, (i) {
        final condition = items[i];
        return Column(
          children: [
            _ConditionRow(condition: condition, maxCount: maxCount),
            if (i < items.length - 1)
              Divider(
                color: context.colors.divider,
                thickness: context.spacing.hairline,
              ),
          ],
        );
      }),
    );
  }
}

class _ConditionRow extends StatelessWidget {
  const _ConditionRow({required this.condition, required this.maxCount});
  final TopConditionModel condition;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final radius = context.radius;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              condition.name,
              style: typography.medicalRecordDetailLabel.copyWith(
                color: colors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius.full),
              child: LinearProgressIndicator(
                value: maxCount == 0 ? 0 : condition.count / maxCount,
                minHeight: spacing.xs,
                valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                backgroundColor: colors.secondary,
              ),
            ),
          ),
          SizedBox(width: spacing.md),
          Text(
            '${condition.count}',
            style: typography.medicalRecordStep.copyWith(color: colors.primary),
          ),
        ],
      ),
    );
  }
}

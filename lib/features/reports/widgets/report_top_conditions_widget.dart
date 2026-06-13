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

    return Column(
      children: List.generate(items.length, (i) {
        final condition = items[i];
        return Column(
          children: [
            _ConditionRow(condition: condition),
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
  const _ConditionRow({required this.condition});
  final TopConditionModel condition;

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
          Container(
            width: spacing.xxl,
            height: spacing.xl,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.accentBlue,
              borderRadius: BorderRadius.circular(radius.sm),
            ),
            child: Text(
              '${condition.count}',
              style: typography.medicalRecordStep.copyWith(
                color: colors.primary,
              ),
            ),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Text(
              condition.name,
              style: typography.medicalRecordDetailBody.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'report_time_period_chip_widget.dart';

class ReportTimePeriodSelectorWidget extends StatelessWidget {
  const ReportTimePeriodSelectorWidget({
    super.key,
    required this.selectedPeriod,
    required this.onSelected,
  });

  final String selectedPeriod;
  final ValueChanged<String> onSelected;

  static const _periods = [
    ('last_7_days', 'reports.period_week'),
    ('last_month', 'reports.period_month'),
    ('last_3_months', 'reports.period_3months'),
    ('all_time', 'reports.period_all_time'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.spacing.md,
      runSpacing: context.spacing.sm,
      children: _periods
          .map(
            (p) => ReportTimePeriodChipWidget(
              labelKey: p.$2,
              isSelected: selectedPeriod == p.$1,
              onTap: () => onSelected(p.$1),
            ),
          )
          .toList(),
    );
  }
}

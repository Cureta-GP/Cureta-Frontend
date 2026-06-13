import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';

class ReportLanguageToggleWidget extends StatelessWidget {
  const ReportLanguageToggleWidget({
    super.key,
    required this.selectedLanguage,
    required this.onSelected,
  });

  final String selectedLanguage;
  final ValueChanged<String> onSelected;

  static const _options = [('en', 'EN'), ('ar', 'عربي')];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius.full),
        border: Border.all(color: colors.divider, width: spacing.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _options
            .map(
              (opt) => _LanguageOption(
                code: opt.$1,
                label: opt.$2,
                isSelected: selectedLanguage == opt.$1,
                onTap: () => onSelected(opt.$1),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.code,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String code;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.radius.full),
      child: AnimatedContainer(
        duration: context.durations.normal,
        padding: EdgeInsets.symmetric(
          horizontal: spacing.xl,
          vertical: spacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(context.radius.full),
        ),
        child: Text(
          label,
          style: typography.medicalRecordChoice.copyWith(
            color: isSelected ? colors.background : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

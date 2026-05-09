import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/settings/view/widgets/row_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

const _supportedLocales = [
  (locale: Locale('en'), label: 'English'),
  (locale: Locale('ar'), label: 'Arabic'),
];

class LanguageSegmentRow extends StatelessWidget {
  const LanguageSegmentRow({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final Locale current;
  final ValueChanged<Locale> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.md,
        vertical: context.spacing.xs,
      ),
      child: Row(
        children: [
          const RowIcon(icon: Icons.language_outlined),
          SizedBox(width: context.spacing.md),
          Expanded(
            child: Text(
              'settings.language'.tr(),
              style: context.typography.body.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          _SegmentedLocaleControl(current: current, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _SegmentedLocaleControl extends StatelessWidget {
  const _SegmentedLocaleControl({
    required this.current,
    required this.onChanged,
  });

  final Locale current;
  final ValueChanged<Locale> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: BorderRadius.circular(context.radius.full),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _supportedLocales.map((entry) {
          final isSelected = entry.locale == current;
          return GestureDetector(
            onTap: () => onChanged(entry.locale),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing.md,
                vertical: context.spacing.xs / 2,
              ),
              decoration: BoxDecoration(
                color: isSelected ? colors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(context.radius.full),
              ),
              child: Text(
                entry.label,
                style: context.typography.label.copyWith(
                  color: isSelected ? Colors.white : colors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'filter_card.dart';

class RecordTypesCard extends StatelessWidget {
  final List<String> availableTypes;
  final Set<String> selectedTypes;
  final ValueChanged<Set<String>> onChanged;

  const RecordTypesCard({
    super.key,
    required this.availableTypes,
    required this.selectedTypes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return FilterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Record types',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: spacing.xs),
          ...availableTypes.map(
            (type) => CheckboxListTile(
              value: selectedTypes.contains(type),
              onChanged: (checked) {
                final updated = Set<String>.from(selectedTypes);
                if (checked == true) {
                  updated.add(type);
                } else {
                  updated.remove(type);
                }
                onChanged(updated);
              },
              title: Text(type),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: colors.primary,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

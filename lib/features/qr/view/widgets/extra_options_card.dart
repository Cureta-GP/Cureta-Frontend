import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'filter_card.dart';

class ExtraOptionsCard extends StatelessWidget {
  final bool includeHistory;
  final int expiryMinutes;
  final ValueChanged<bool> onIncludeHistoryChanged;
  final ValueChanged<int> onExpiryChanged;

  const ExtraOptionsCard({
    super.key,
    required this.includeHistory,
    required this.expiryMinutes,
    required this.onIncludeHistoryChanged,
    required this.onExpiryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FilterCard(
      child: Column(
        children: [
          SwitchListTile(
            value: includeHistory,
            onChanged: onIncludeHistoryChanged,
            title: const Text('Include history'),
            activeThumbColor: colors.primary,
            contentPadding: EdgeInsets.zero,
          ),
          DropdownButtonFormField<int>(
            initialValue: expiryMinutes,
            decoration: const InputDecoration(
              labelText: 'Link expires in',
              border: OutlineInputBorder(),
            ),
            items: const [15, 30, 60, 120]
                .map(
                  (m) => DropdownMenuItem(value: m, child: Text('$m minutes')),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) onExpiryChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

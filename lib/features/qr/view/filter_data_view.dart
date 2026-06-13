import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class FilterDataView extends StatefulWidget {
  const FilterDataView({super.key});

  @override
  State<FilterDataView> createState() => _FilterDataViewState();
}

class _FilterDataViewState extends State<FilterDataView> {
  String selectedCategory = 'Medications';
  TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 0);

  final List<String> categories = [
    'Medications',
    'Allergies',
    'Conditions',
    'Emergency contacts',
  ];

  final Map<String, bool> checkboxes = {
    'Show medications': true,
    'Show allergies': true,
    'Show conditions': true,
    'Show emergency contacts': false,
  };

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        title: const Text('Filter data'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose what to show in your QR summary',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: spacing.xs),
              Text(
                'Select a category, time range, and the sections you want to share.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
              ),
              SizedBox(height: spacing.lg),
              Expanded(
                child: ListView(
                  children: [
                    _buildCard(
                      context,
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Data category',
                          border: OutlineInputBorder(),
                        ),
                        items: categories
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedCategory = value);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: spacing.md),
                    _buildCard(
                      context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time range',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: spacing.sm),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _pickTime(context, true),
                                  icon: const Icon(Icons.access_time),
                                  label: Text(
                                    'Start: ${startTime.format(context)}',
                                  ),
                                ),
                              ),
                              SizedBox(width: spacing.sm),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _pickTime(context, false),
                                  icon: const Icon(Icons.access_time_filled),
                                  label: Text(
                                    'End: ${endTime.format(context)}',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: spacing.md),
                    _buildCard(
                      context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select sections',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: spacing.xs),
                          ...checkboxes.entries.map(
                            (entry) => CheckboxListTile(
                              value: entry.value,
                              onChanged: (value) {
                                setState(
                                  () => checkboxes[entry.key] = value ?? false,
                                );
                              },
                              title: Text(entry.key),
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: colors.primary,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Apply filters'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    final colors = context.colors;
    final radius = context.radius;
    final spacing = context.spacing;

    return Card(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.lg),
        side: BorderSide(color: colors.divider),
      ),
      child: Padding(padding: EdgeInsets.all(spacing.md), child: child),
    );
  }
}
